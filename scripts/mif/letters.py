import sys
import os
import operator

def read_mif_file(path):
    with open(path) as f:
        contents = f.readlines()
    return contents[6:len(contents) - 1]

def write_index_file(sorted_indices, path):
    text_file = open(path + "index/index.mif", "w")
    for tup in sorted_indices:
        text_file.write(hex(tup[1])[2:] + ":" + tup[0] + ";\n")
    text_file.close()

def generate_indices(mif_files):
    indices = {}
    i = 366
    for mif in mif_files:
        for line in read_mif_file(mif):
            components = line.split(':')
            index = components[0].strip()
            color = components[1].strip()
            if(color not in indices):
                indices[color] = i
                i += 1
    return indices

def write_dmem_file(indices, mif_files, start):
    pos = start
    dmem_file = open(path + "dmem/dmem.mif", "w")
    for mif_file in mif_files:
        for line in read_mif_file(mif_file):
            components = line.split(':')
            index = components[0].strip()
            color = components[1].strip()
            dmem_file.write(str(pos) + ":" + bin(indices[color])[2:] + ";\n")
            pos += 1
    dmem_file.close()

if __name__ == '__main__':
    print "Processing letters directory..."
    path = "../../assets/letters/"
    if not os.path.isdir(path):
        raise Exception("ERROR: the directory does not exist.")
    mif_files = [os.path.join(path, f) for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) and os.path.splitext(f)[1][1:] == 'mif']
    print "Generating indices..."
    indices = generate_indices(mif_files)
    sorted_indices = sorted(indices.items(), key=operator.itemgetter(1))
    print "Writing indices to file..."
    write_index_file(sorted_indices, path)
    print "Writing to DMEM..."
    write_dmem_file(indices, mif_files, 3600)
    print "DONE"
