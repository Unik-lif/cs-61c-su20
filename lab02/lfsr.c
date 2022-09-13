#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"


uint16_t get_bit(uint16_t x, uint16_t n) {
    return ((x << (15 - n)) >> 15);
}

void set_bit(uint16_t * x, uint16_t n, uint16_t v) {
    uint16_t helper_upper = 0xffff;
    uint16_t helper_lower = 0xffff;

    if (n == 15) helper_upper = 0x0;
    else helper_upper <<= (n + 1);
    if (n == 0) helper_lower = 0x0;
    else helper_lower = (helper_lower << (16 - n)) >> (16 - n);
    
    (*x) = (v << n) | (helper_lower & (*x)) | (helper_upper & (*x));
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t zero = get_bit(*reg, 0);
    uint16_t two = get_bit(*reg, 2);
    uint16_t three = get_bit(*reg, 3);
    uint16_t five = get_bit(*reg, 5);
    uint16_t temp = zero ^ two;
    temp = temp ^ three;
    temp = temp ^ five;
    *(reg) = *(reg) >> 1;
    set_bit(reg, 15, temp);
}