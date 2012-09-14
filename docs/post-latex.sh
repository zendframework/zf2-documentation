#!/bin/sh

#
# Include the grffile package to allow dots in included graphic file names.
#
sed -i '12 a\
\\usepackage{grffile}
' $1

#
# Strip all non-ASCII characters (which pdflatex doesn't seem to be able to deal with).
#
tr -cd '\11\12\15\40-\176' < $1 > ${1}.$$
mv ${1}.$$ $1
