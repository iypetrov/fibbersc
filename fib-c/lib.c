#include <stdio.h>

__attribute__((visibility("default"))) int fib(int n) {
    if (n <= 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}
