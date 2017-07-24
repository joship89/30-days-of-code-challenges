# Enter your code here. Read input from STDIN. Print output to STDOUT

vals = int(raw_input())

phoneBook = {}

for x in range(0, vals):
    text = raw_input().split() 
    phoneBook[text[0]] = text[1]
    
    
for y in range(vals, vals + vals):
    text = raw_input().split()
    
    if phoneBook.has_key(text[0]):
        print text[0].strip("[]") + "=" + phoneBook[text[0]]
    else: 
        print "Not found"
        
