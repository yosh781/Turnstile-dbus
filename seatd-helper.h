/* seatd-helper.h - интеграция turnstile-dbus с seatd */
#ifndef SEATD_HELPER_H
#define SEATD_HELPER_H

#include <libseat.h>

/* Инициализация подключения к seatd */
int seatd_helper_init(void);

/* Получение DRM fd для сессии */
int seatd_helper_get_drm_fd(unsigned long session_id);

/* Получение input fd для сессии */
int seatd_helper_get_input_fds(int **fds, int *count, unsigned long session_id);

/* Закрытие соединения */
void seatd_helper_cleanup(void);

#endif
