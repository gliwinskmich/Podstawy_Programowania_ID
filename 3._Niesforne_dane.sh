#!/bin/bash

input_file="dane.txt"
output_file="dane_w_kolumnach.txt"

echo "Kolumny w pliku tekstowym"
echo ""

#czyszczenie pliku ze znaków nowej linii
tr -d '\r' < "$input_file" | awk 'NF > 0' > temp_cleaned.txt

#układanie w kolumny
awk '
BEGIN {print "x\ty\tz"}
NR%3==1 {x=$0}
NR%3==2 {y=$0}
NR%3==0 {z=$0; print x "\t" y "\t" z}
' temp_cleaned.txt > "$output_file"

#sprzątanie
rm temp_cleaned.txt
echo "> gotowy plik \"dane_w_kolumnach.txt\" znajduje się w obecnym katalogu."