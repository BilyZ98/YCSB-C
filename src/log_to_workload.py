#!/bin/env python3
import sys

OPS = ["INSERT", "READ", "UPDATE", "DELETE", "READMODIFYWRITE"]

if (len(sys.argv) < 2):
    print("usage : {} input_file".format(sys.argv[0]))

input_filename = sys.argv[1]
output_load_filename = input_filename+"_load.formated"
output_run_filename = input_filename+"_run.formated"
print("write in " + output_load_filename + " and " + output_run_filename)


# input_file = open(input_filename)
# input_lines = input_file.readlines()

output_load_file = open(output_load_filename, "w")
output_run_file = open(output_run_filename, "w")
output_load_lines = []
output_run_lines = []

is_load = True
flush_count = 1000000
with open(input_filename) as f:
    for l in f:
        ls = l.split()
        if (len(ls) < 1):
            continue
        if ls[0] in OPS:
            line = "{} {}\n".format(ls[0], ls[2][4:])
            if ls[0] == "INSERT":
                output_load_lines.append(line)
            else:
                output_run_lines.append(line)
            #print(line)
        elif ls[0] == '#':
            is_load = False
        elif ls[0] == "SCAN":
            line = "{} {} {}\n".format(ls[0], ls[2][4:], ls[3])
            if is_load:
                output_load_lines.append(line)
            else:
                output_run_lines.append(line)
        if is_load and len(output_load_lines) > flush_count :
            print(len(output_load_lines))
            output_load_file.writelines(output_load_lines)
            output_load_lines = []
        if not is_load and len(output_run_lines) > flush_count :
            print(len(output_run_lines))
            output_run_file.writelines(output_run_lines)
            output_run_lines = []

print("load count: ", len(output_load_lines))
output_load_file.writelines(output_load_lines)
print("run count: ", len(output_run_lines))
output_run_file.writelines(output_run_lines)

# input_file.close()
output_load_file.close()
output_run_file.close()

