#!/bin/bash

#plik tymczasowy
temp_file=$(mktemp)

echo "Treść występująca wyłącznie w pliku \"en-7.4.json5\""
echo "Porównywanie zawartości plików..."

grep -Fxvf "en-7.2.json5" "en-7.4.json5" > "$temp_file"

#dodanie nawiasów klamrowych na początku i końcu
{
    echo "{"
    cat "$temp_file"
    echo "}"
} > "only_en-7.4.json5"

rm "$temp_file"
echo "Program zakończył pracę."
echo "Unikalną treść zapisano do pliku \"only_en-7.4.json5\""