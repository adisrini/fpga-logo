#!/bin/sh
dir=$1
end_dmem=$2
end_index=$3
path="../../assets/turtles/"$dir
mkdir $path"/index"
mkdir $path"/dmem"
/Applications/MATLAB_R2016a.app/bin/matlab -nodesktop -r "img2mif_file('"$path"/"$dir"n.png', '"$path"/"$dir"n.mif'); img2mif_file('"$path"/"$dir"e.png', '"$path"/"$dir"e.mif'); img2mif_file('"$path"/"$dir"w.png', '"$path"/"$dir"w.mif'); img2mif_file('"$path"/"$dir"s.png', '"$path"/"$dir"s.mif'); quit"
python mifify.py $dir $end_dmem $end_index
