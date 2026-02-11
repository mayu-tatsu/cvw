// mul_add.c

#include <stdint.h>
#include "util.h"

int add_q31(int a, int b) {
    return a + b;
}

int mul_q31(int a, int b) {
    long res = (long)a * (long)b;
    int result = (int)(res >> 31);
    return result;
}
