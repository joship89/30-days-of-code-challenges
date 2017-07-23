#!/bin/python

import sys


n = int(raw_input().strip())
arr = map(int,raw_input().strip().split(' '))

rev = arr[::-1]

print ' '.join(map(str, rev))

