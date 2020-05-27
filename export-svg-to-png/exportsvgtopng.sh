#! /bin/bash
# exportsvgtopng.sh
# Script to export SVGs in PNGs in different sizes using Inkscape.
# Originally written by Armand Philippot <contact@armandphilippot.com>.

###############################################################################
#
# MIT License

# Copyright (c) 2020 Armand Philippot

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################

echo -e "This script allows you to export your SVG files to PNG in different sizes using Inkscape.\n"

if command -v inkscape &>/dev/null; then
    echo -e "Inkscape is installed, let's continue.\n"
else
    echo -e "Inkscape is not installed.\n"
    exit 2
fi

echo -e "The folder to be processed must contain subdirectories containing your SVG files."
read -rp 'Enter the folder path to be processed: ' BASEDIR
if [ -d "$BASEDIR" ]; then
    echo -e "The folder to be processed exists, let's continue.\n"
    [[ "${BASEDIR}" != */ ]] && BASEDIR="${BASEDIR}/"
else
    until [ -d "$BASEDIR" ]; do
        echo -e "The folder to be processed does not exist. Please enter a valid path.\n"
        read -rp 'Enter the folder path to be processed: ' BASEDIR
    done
fi

read -rp 'Enter the exit path: ' OUTPATH
if [ -d "$OUTPATH" ]; then
    echo "The exit path exists, let's continue."
    [[ "${OUTPATH}" != */ ]] && OUTPATH="${OUTPATH}/"
else
    until [ -d "$OUTPATH" ]; do
        echo -e "The exit path does not exist. Please enter a valid path.\n"
        read -rp 'Enter the exit path: ' OUTPATH
    done
fi

read -rp 'Enter the number of sizes desired: ' SIZES
until [[ "$SIZES" = *([+-])*([0-9])*(.)*([0-9]) ]]; do
    echo -e "The value entered is not a number, please try again.\n"
    read -rp 'Enter the number of sizes desired: ' SIZES
done

echo -e "You will now enter the different desired sizes ($SIZES in total).\n"
for ((i = 1; i < SIZES + 1; i++)); do
    read -rp "Enter the size $i: " SIZE[$i]
    until [[ "${SIZE[$i]}" = *([+-])*([0-9])*(.)*([0-9]) ]]; do
        echo -e "The value entered is not a number, please try again.\n"
        read -rp "Enter the size $i: " SIZE[$i]
    done
done

echo "The requested sizes are: "
for ((i = 1; i < SIZES + 1; i++)); do
    echo "${SIZE[$i]}"
done

echo -e "We will now proceed with the conversion.\n"
for dir in "${BASEDIR}"*; do
    if [ -d "$dir" ]; then
        subdir=$(basename "$dir")
        for ((i = 1; i < SIZES + 1; i++)); do
            SIZEDIR="${SIZE[$i]}x${SIZE[$i]}"
            mkdir -p "${OUTPATH}${SIZEDIR}/${subdir}"
            FULLOUTPATH="${OUTPATH}${SIZEDIR}/${subdir}"
            shopt -s nullglob
            for file in "$dir"/*.svg; do
                MYFILENAME=$(basename "$file" .svg)
                /usr/bin/inkscape "${file}" --export-filename "${FULLOUTPATH}"/"${MYFILENAME}".png -C -w "${SIZE[$i]}" -h "${SIZE[$i]}"
            done
        done
    fi
done

echo -e "\nThe files have been converted.\n"
