import sys
import os
import operator

def read_mif_file(path):
    with open(path) as f:
        contents = f.readlines()
    return contents[6:len(contents) - 1]

def write_index_file(sorted_indices, path):
    text_file = open(path + "/index/index.mif", "w")
    for tup in sorted_indices:
        text_file.write(hex(tup[1])[2:] + ":" + tup[0] + ";\n")
    text_file.close()

def generate_indices(mif_files, start):
    mif_file = mif_files[0] # only need to take one of the files
    indices = {}
    i = int(start)
    for line in read_mif_file(mif_file):
        components = line.split(':')
        index = components[0].strip()
        color = components[1].strip()
        if(color not in indices):
            indices[color] = i
            i += 1
    return indices

def write_dmem_file(indices, path, start):
    prefix = path + "/" + sys.argv[1]
    suffixes = ["n.mif", "e.mif", "s.mif", "w.mif"]
    pos = int(start)*900
    dmem_file = open(path + "/dmem/dmem.mif", "w")
    for suffix in suffixes:
        for line in read_mif_file(prefix + suffix):
            components = line.split(':')
            index = components[0].strip()
            color = components[1].strip()
            dmem_file.write(str(pos) + ":" + bin(indices[color])[2:] + ";\n")
            pos += 1
    dmem_file.close()

if __name__ == '__main__':
    args = sys.argv
    if(len(args) != 4):
        raise Exception("Please enter two arguments: the directory of the turtle image to process and the index of the turtle image.")
    print "Processing directory \"" + sys.argv[1] + "\"..."
    path = "../../assets/turtles/" + sys.argv[1]
    if not os.path.isdir(path):
        raise Exception("ERROR: the directory provided does not exist.")
    mif_files = [os.path.join(path, f) for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) and os.path.splitext(f)[1][1:] == 'mif']
    print "Generating indices..."
    indices = generate_indices(mif_files, sys.argv[3])
    sorted_indices = sorted(indices.items(), key=operator.itemgetter(1))
    print "Writing indices to file..."
    write_index_file(sorted_indices, path)
    print "Writing to DMEM..."
    write_dmem_file(indices, path, sys.argv[2])
    print "DONE"
