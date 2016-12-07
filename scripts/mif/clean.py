import sys
import os
import operator

def read_mif_file(path):
    with open(path) as f:
        contents = f.readlines()
    return contents

def clean(path):
    write = open("imem_clean.mif", "w")

    lines = read_mif_file(path)
    pattern = [3, 1, 1, 10, 10000]
    pattern_index = 0
    sub_index = 0
    line_pos = 0

    ## SW -> SVGA
    for line in lines:
        if ':' in line:
            components = line.split(':')
            index = components[0]
            value = components[1]
            if value[0:11] == ' 0011100110':
                value = ' 0111100110' + value[11:]
            elif value[0:14] == ' 0011101101110':
                value = ' 0111101101110' + value[14:]
            elif value[0:11] == ' 0011111001':
                value = ' 0111111001' + value[11:]
            elif value[0:6] == ' 00010':
                if pattern_index % 2 == 0:      # replace
                    value = ' 11101' + value[6:]
                sub_index += 1
                if sub_index == pattern[pattern_index]:
                    sub_index = 0
                    pattern_index += 1
            write.write(index + ':' + value)
        else:
            write.write(line)

    write.close()

if __name__ == '__main__':
    print("Processing mif file...")
    path = sys.argv[1]
    if not os.path.isfile(path):
        print("ERROR: the file does not exist.")
    else:
        print("Writing to mif file...")
        clean(path)
        print("DONE")
