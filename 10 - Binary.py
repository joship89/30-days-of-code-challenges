#!/bin/python

import sys

n = int(input())

rem = 0
max_rem = 0

while n > 0:
    if n % 2 == 1:
        rem += 1
        if rem > max_rem:
            max_rem = rem

    else:
        rem = 0

    n //= 2

print max_rem
