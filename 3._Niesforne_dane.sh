#!/bin/bash

input_file="dane.txt"
output_file="dane_w_kolumnach.txt"

#nagłówki
echo -e "x\ty\tz" > "$output_file"

#przetwarzanie pliku
awk 'NR%3==1 {x=$0; getline; y=$0; getline; z=$0; print x "\t" y "\t" z}' "$input_file" >> "$output_file"