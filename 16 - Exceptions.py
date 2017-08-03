#!/bin/python

import sys


S = raw_input().strip()

def string_to_num(s):
    try:
        print int(s)
    except ValueError:
        print "Bad String"

string_to_num(S)