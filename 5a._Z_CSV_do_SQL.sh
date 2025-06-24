#!/bin/bash

input_file="steps-2sql.csv"
output_file="dane.sql"

#sprawdzenie czy plik źródłowy istnieje
if [ ! -f "$input_file" ]; then
echo "Plik źródłowy $input_file nie istnieje!"
exit 1
fi

#obliczenie liczby rekordów (pomijając nagłówek)
total_records=$(($(wc -l < "$input_file") - 1))
echo "CSV -> SQL"
echo "Konwersja pliku \"$input_file\" (liczba rekordów: $total_records) do pliku \"$output_file\""
echo ""
echo "Trwa konwersja..."

#czas rozpoczęcia (dla użytkownika)
start_time=$(date +%s)

#generowanie SQL za pomocą awk z paskiem postępu (pasek postępu dla użytkownika)
awk -F';' -v total="$total_records" '
BEGIN {
#paska postępu
printf "[%-100s] 0%%", "" > "/dev/stderr"
}
NR == 1 { next } # Pomijamy nagłówek
{
gsub(/[[:space:]]/, "", $0); # Usuwamy białe znaki
printf "INSERT INTO stepsData (time, intensity, steps) VALUES (%s, %s, %s);\n", $1, $2, $3

#aktualizacja paska postępu
progress = int((NR-1)/total*100)
if (progress != prev_progress) {
printf "\r[%-100s] %d%%", substr("####################################################################################################", 1, progress+1), progress > "/dev/stderr"
fflush("/dev/stderr")
prev_progress = progress
}
}
END {
printf "\r[%-100s] 100%%\n", "####################################################################################################" > "/dev/stderr"
}
' "$input_file" > "$output_file"

#czas zakończenia (dla użytkownika)
end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "Zakończono sukcesem konwersję $total_records rekordów w $duration s."
echo "Wynik zapisano w pliku \"$output_file\""