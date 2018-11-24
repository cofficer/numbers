#!/bin/bash
# filenames=find . -name "*.m"
# -exec cp {} ~/Documents/MATLAB/ktsetsos/plots/overviews/

# example of using arguments to a script
# echo "My first name is $filenames"
for f in P*/Overview*;
do
  substr1=$(echo $f| cut -d'/' -f 1);
  substr2=$(echo $f| cut -d'/' -f 2);
  cp -v -- "$f" ~/Documents/MATLAB/ktsetsos/plots/overviews/${substr1}_${substr2} 
done
