#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns
    // 0 or 1)
    return ((x << (31 - n)) >> 31);
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    // YOUR CODE HERE
    unsigned helper_upper = 0xffffffff;
    unsigned helper_lower = 0xffffffff;

    if (n == 31) helper_upper = 0x0;
    else helper_upper <<= (n + 1);
    if (n == 0) helper_lower = 0x0;
    else helper_lower = (helper_lower << (32 - n)) >> (32 - n);
    
    (*x) = (v << n) | (helper_lower & (*x)) | (helper_upper & (*x));
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    // YOUR CODE HERE
    set_bit(x, n, !get_bit(*x, n));
}

