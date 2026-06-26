#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <syslog.h>
#include <errno.h>
#include "seatd-helper.h"

static struct libseat *seatd_conn = NULL;

static void seatd_enable_seat(struct libseat *seat, void *data) {
    (void)seat;
    (void)data;
    syslog(LOG_INFO, "libseat: seat enabled");
}

static void seatd_disable_seat(struct libseat *seat, void *data) {
    (void)seat;
    (void)data;
    syslog(LOG_INFO, "libseat: seat disabled");
    /* Acknowledge disable immediately */
    libseat_disable_seat(seat);
}

int seatd_helper_init(void) {
    struct libseat_seat_listener listener = {
        .enable_seat = seatd_enable_seat,
        .disable_seat = seatd_disable_seat
    };
    
    seatd_conn = libseat_open_seat(&listener, NULL);
    if (seatd_conn) {
        syslog(LOG_INFO, "seatd-helper: Connected to seatd successfully");
        return 0;
    }
    syslog(LOG_INFO, "seatd-helper: seatd not available, will use direct device access");
    return -1;
}

int seatd_helper_get_drm_fd(unsigned long session_id) {
    int drm_fd = -1;
    
    /* Try seatd first */
    if (seatd_conn) {
        syslog(LOG_INFO, "seatd-helper: requesting DRM from seatd for session %lu", session_id);
        
        const char *drm_paths[] = {
            "/dev/dri/card0",
            "/dev/dri/card1", 
            "/dev/dri/renderD128",
            NULL
        };
        
        for (int i = 0; drm_paths[i]; i++) {
            int id = libseat_open_device(seatd_conn, drm_paths[i], &drm_fd);
            if (id != -1 && drm_fd >= 0) {
                syslog(LOG_INFO, "seatd-helper: opened %s via seatd (id=%d, fd=%d)", 
                       drm_paths[i], id, drm_fd);
                break;
            }
        }
    }
    
    /* Fallback: open directly */
    if (drm_fd < 0) {
        const char *dri_paths[] = {
            "/dev/dri/card0",
            "/dev/dri/card1",
            "/dev/dri/renderD128",
            NULL
        };
        
        for (int i = 0; dri_paths[i]; i++) {
            drm_fd = open(dri_paths[i], O_RDWR | O_CLOEXEC);
            if (drm_fd >= 0) {
                syslog(LOG_INFO, "seatd-helper: direct opened %s (fd=%d)", 
                       dri_paths[i], drm_fd);
                break;
            }
        }
    }
    
    if (drm_fd < 0) {
        syslog(LOG_ERR, "seatd-helper: failed to get DRM fd for session %lu", session_id);
    }
    
    return drm_fd;
}

int seatd_helper_get_input_fds(int **fds, int *count, unsigned long session_id) {
    (void)session_id;
    *fds = NULL;
    *count = 0;
    
    if (seatd_conn) {
        syslog(LOG_INFO, "seatd-helper: requesting input devices from seatd");
        
        int max_devices = 32;
        *fds = malloc(max_devices * sizeof(int));
        if (!*fds) return -1;
        
        char path[64];
        for (int i = 0; i < max_devices; i++) {
            snprintf(path, sizeof(path), "/dev/input/event%d", i);
            int fd;
            if (libseat_open_device(seatd_conn, path, &fd) != -1 && fd >= 0) {
                (*fds)[(*count)++] = fd;
            }
        }
        
        if (*count == 0) {
            free(*fds);
            *fds = NULL;
        }
    }
    
    return (*count > 0) ? 0 : -1;
}

void seatd_helper_cleanup(void) {
    if (seatd_conn) {
        libseat_close_seat(seatd_conn);
        seatd_conn = NULL;
        syslog(LOG_INFO, "seatd-helper: disconnected from seatd");
    }
}
