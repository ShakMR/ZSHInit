#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>

struct WindowSize {
	int cols;
	int rows;
};

WindowSize getWindowSize ()
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);

    WindowSize ret;
    ret.cols = w.ws_col;
    ret.rows = w.ws_row;
    return ret;  // make sure your main returns int
}