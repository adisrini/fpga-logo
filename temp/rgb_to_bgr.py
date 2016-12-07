import sys
import os

def convert(file_name):
    write_file = open('index_bgr.mif', 'w')
    with open(file_name) as f:
        content = f.readlines()
    for line in content:
        split = line.split(':')
        index = split[0]
        value = split[1]
        r_val = value[0:2]
        g_val = value[2:4]
        b_val = value[4:6]
        flipped_line = index + ':' + b_val + g_val + r_val + ';\n'
        write_file.write(flipped_line)
    write_file.close()

if __name__ == '__main__':
    file_name = sys.argv[1]
    print "Processing file..."
    print "Writing to file..."
    convert(file_name)
    print "DONE"
