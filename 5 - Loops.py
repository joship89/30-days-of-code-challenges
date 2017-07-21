#!/bin/python

import sys


n = int(raw_input().strip())

for i in range(1,11):
        print "%i x %i = %i" %(n, i, n * i)
