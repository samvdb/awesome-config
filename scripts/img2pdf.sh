#!/bin/bash
for f in $@
do
convert $f $f.pdf
done && zenity --info --text "Done!"
