#!/bin/sh

input_file="en-7.2.json5"
output_file="pl-7.2.json5"

echo "Dodawanie uwag tłumacza w toku..."

awk '
{   
    #linie zawierające wyłącznie nawiasy lub linie puste są przepisywane bez zmian
    if ($0 ~ /^[[:space:]]*[{}][[:space:]]*$/ || $0 ~ /^[[:space:]]*$/)
    {
        print $0
    } 
    else 
    {
        #dla pozostałych, najpierw przepisywana jest linia bez zmian, następnie bez białych znaków na początku i końcu z dodanym komentarzem //
        print $0
        sub(/^[[:space:]]+/, "", $0)
        sub(/[[:space:]]+$/, "", $0)
        print "// " $0
    }
}
' "$input_file" > "$output_file"

echo "Program zakończył pracę."
echo "Plik ze zmianami zapisano w $output_file."