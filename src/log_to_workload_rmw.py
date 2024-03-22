#!/bin/env python3
import sys

OPS = ["INSERT", "READ", "UPDATE", "DELETE", "READMODIFYWRITE"]

if (len(sys.argv) < 2):
    print("usage : {} input_file".format(sys.argv[0]))

input_filename = sys.argv[1]
output_filename = input_filename+".formated"
print("write in " + output_filename)


input_file = open(input_filename)
input_lines = input_file.readlines()

output_file = open(output_filename, "w")
output_lines = []

for l in input_lines:
    ls = l.split()
    if (len(ls) < 1):
        continue
    if ls[0] in OPS:
        line = "{} {}\n".format(ls[0], ls[2][4:])
        output_lines.append(line)
        #print(line)
    elif ls[0] == "SCAN":
        line = "{} {} {}\n".format(ls[0], ls[2][4:], ls[3])
        output_lines.append(line)

input_file.close()


lines_size = len(output_lines)

output2_lines = []

i = 0

while i < lines_size:
    l1s = output_lines[i].split()
    if (i+1 == lines_size):
        output2_lines.append(output_lines[i])
        i+=1
        continue
    l2s = output_lines[i+1].split()
    if (l1s[0] == "READ" and l2s[0] == "UPDATE" and l1s[1] == l2s[1]):
        line = "{} {}\n".format("READMODIFYWRITE", l1s[1])
        output2_lines.append(line)
        i+=2
    else:
        output2_lines.append(output_lines[i])
        i+=1



print(len(output2_lines) , " OPs")
output_file.writelines(output2_lines)

output_file.close()
