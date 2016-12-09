import sys
import os
import operator

def read_mif_file(path):
    with open(path) as f:
        contents = f.readlines()
    return contents[6:len(contents)-1]

def write_index_file(sorted_indices, path):
    text_file = open("index.mif", "w")
    for tup in sorted_indices:
        text_file.write(hex(tup[1])[2:] + ":" + tup[0] + ";\n")
    text_file.close()

def generate_indices(mif_file):
    indices = {}
    i = 0
    for line in read_mif_file(mif_file):
        components = line.split(':')
        index = components[0].strip()
        color = components[1].strip()
        if(color not in indices):
            indices[color] = i
            i += 1
    return indices

def write_dmem_file(indices, mif_file, start):
    pos = start
    dmem_file = open("dmem.mif", "w")
    for line in read_mif_file(mif_file):
        components = line.split(':')
        index = components[0].strip()
        color = components[1].strip()
        dmem_file.write(str(pos) + ":" + bin(indices[color])[2:] + ";\n")
        pos += 1
    dmem_file.close()

if __name__ == '__main__':
    print "Processing letters directory..."
    path = "splash_blue2.mif"
    indices = generate_indices(path)
    sorted_indices = sorted(indices.items(), key=operator.itemgetter(1))
    print "Writing indices to file..."
    write_index_file(sorted_indices, path)
    print "Writing to DMEM..."
    write_dmem_file(indices, path, 0)
    print "DONE"
