import sys

t = int(raw_input())

for i in range(0,t):
    text = raw_input()
    print text[0:len(text):2] , text[1:len(text):2]
