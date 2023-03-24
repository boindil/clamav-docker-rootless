#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>

#ifdef CL_THREAD_SAFE
#include <pthread.h>
pthread_mutex_t logg_mutex     = PTHREAD_MUTEX_INITIALIZER;
#endif

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("expected exactly 1 argument (file to check).\n");
        exit(-1);
    }

    FILE *logg_fp = NULL;
    const char *logg_file = argv[1];
    mode_t old_umask;
#ifdef F_WRLCK
    struct flock fl;
#endif

    old_umask = umask(0037);
    if ((logg_fp = fopen(logg_file, "at")) == NULL) {
        umask(old_umask);
#ifdef CL_THREAD_SAFE
        pthread_mutex_unlock(&logg_mutex);
#endif
        // printf("ERROR: Can't open %s in append mode (check permissions!).\n", logg_file);
        exit(1);
    } else {
        umask(old_umask);
    }

#ifdef F_WRLCK
    memset(&fl, 0, sizeof(fl));
    fl.l_type = F_WRLCK;
    if (fcntl(fileno(logg_fp), F_SETLK, &fl) == -1) {
#ifdef EOPNOTSUPP
        if (errno == EOPNOTSUPP)
            // printf("WARNING: File locking not supported (NFS?)\n");
            exit(0);
        else
#endif
        {
#ifdef CL_THREAD_SAFE
            pthread_mutex_unlock(&logg_mutex);
#endif
            // printf("ERROR: %s is locked by another process\n", logg_file);
            exit(2);
        }
    } else {
        fcntl(fileno(logg_fp), F_UNLCK, &fl);
    }
#endif

    exit(0);
}
