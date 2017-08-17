#!/bin/python

import sys
import re

names = []
emails = []

N = int(raw_input().strip())
for i in xrange(N):
    data = raw_input().strip().split(' ')
    firstName = data[0]
    emailID = data[1]
    if re.search('gmail', emailID) :
        names.append(firstName)
    
names.sort()

for name in names:
    print (name)