#!/bin/bash

input_file="steps-2sql.csv"
output_file="dane.sql"

# Sprawdzenie czy plik źródłowy istnieje
if [ ! -f "$input_file" ]; then
echo "Plik źródłowy $input_file nie istnieje!"
exit 1
fi

# Obliczenie liczby rekordów (pomijając nagłówek)
total_records=$(($(wc -l < "$input_file") - 1))

echo "Konwersja $input_file ($total_records rekordów) do $output_file..."
echo "To może chwilę potrwać..."

# Czas rozpoczęcia
start_time=$(date +%s)

# Generowanie SQL za pomocą awk - znacznie szybsze
awk -F';' '
NR == 1 { next } # Pomijamy nagłówek
{
gsub(/[[:space:]]/, "", $0); # Usuwamy białe znaki
printf "INSERT INTO stepsData (time, intensity, steps) VALUES (%s, %s, %s);\n", $1, $2, $3
}
' "$input_file" > "$output_file"

# Czas zakończenia
end_time=$(date +%s)
duration=$((end_time - start_time))

echo "Zakończono sukcesem konwersję $total_records rekordów w $duration sekund."
echo "Wynik zapisano w pliku $output_file"
