#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/select.h>
#include <errno.h>

#include <libnotify/notify.h>

#define DEFAULT_NB_SECS 5

int main (int argc, char* argv[]) {
    int nb_secs;
    char buffer[100];
    const char* title = "Screen locked in ";
    const char* img   = "appointment-soon";
    NotifyNotification* notif;
    struct timespec timeout;
    fd_set readset;
    int keyboard_fd;
    int mouse_fd;
    int select_result;

    /* Refresh each seconds */
    timeout.tv_sec = 1;
    timeout.tv_nsec = 0;

    /* Total timeout given as an argument.  */
    if(argc > 1)
    {
        nb_secs = atoi(argv[1]);
    }
    else
    {
        nb_secs = DEFAULT_NB_SECS;
    }

    /* Initialize notification. */
    notify_init ("ScreenSaverTimeout");
    notif = notify_notification_new (title, NULL, img);

    /* Initialize file descriptors. */
    mouse_fd = open("/dev/input/mice", O_RDONLY);
    keyboard_fd = open("/dev/input/event0", O_RDONLY);

    if((mouse_fd < 0) || (keyboard_fd < 0))
        return EXIT_FAILURE;

    for(; nb_secs != 0; nb_secs--) {
        /* Update and show notification */
        sprintf(buffer, "%d", nb_secs);
        notify_notification_update(notif, title, buffer, img);
        notify_notification_show (notif, NULL);

        /* Wait 1s. Break if there is an input. */
        FD_ZERO(&readset);
        FD_SET(keyboard_fd, &readset);
        FD_SET(mouse_fd, &readset);
        select_result = pselect(keyboard_fd + 1, &readset, NULL, NULL, &timeout, NULL);
        if(select_result) break;
    }

    /* Close everything */
    close(mouse_fd);
    close(keyboard_fd);

    notify_notification_close(notif, NULL);
    g_object_unref(G_OBJECT(notif));
    notify_uninit();

    return EXIT_SUCCESS;
}


