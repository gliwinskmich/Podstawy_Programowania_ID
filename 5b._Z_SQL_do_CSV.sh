#!/bin/bash

input_file="steps-2csv.sql"
output_file="dane.csv"

#sprawdzenie czy plik źródłowy istnieje
if [ ! -f "$input_file" ]; then
    echo "Plik źródłowy $input_file nie istnieje!"
    exit 1
fi

#obliczenie liczby rekordów
total_records=$(grep -c "INSERT INTO" "$input_file")
echo "SQL -> CSV"
echo "Konwersja pliku \"$input_file\" (liczba rekordów: $total_records) do pliku \"$output_file\""
echo ""
echo "Trwa konwersja..."

#czas rozpoczęcia (dla użytkownika)
start_time=$(date +%s)

#nagłówek CSV
echo "dateTime;steps;synced" > "$output_file"

#generowanie CSV za pomocą awk z paskiem postępu (pasek postępu dla użytkownika)
awk -v total="$total_records" '
BEGIN {
#pasek postępu
printf "[%-100s] 0%%", "" > "/dev/stderr"
}
/INSERT INTO stepsData \(dateTime, steps, synced\) VALUES/ {
#wartości z VALUES
match($0, /VALUES *\(([^,]+),([^,]+),([^)]+)\)/, arr)
dateTime = substr(arr[1], 1, length(arr[1])-3) # Obcinamy 3 ostatnie znaki
steps = arr[2]
synced = arr[3]

#usuwanie ewentualnych białych znaków
gsub(/ /, "", dateTime)
gsub(/ /, "", steps)
gsub(/ /, "", synced)

#zapis do CSV
printf "%s;%s;%s\n", dateTime, steps, synced >> "'"$output_file"'"

#aktualizacja paska postępu
processed++
progress = int(processed/total*100)
if (progress != prev_progress) {
printf "\r[%-100s] %d%%", substr("####################################################################################################", 1, progress+1), progress > "/dev/stderr"
fflush("/dev/stderr")
prev_progress = progress
}
}
END {
printf "\r[%-100s] 100%%\n", "####################################################################################################" > "/dev/stderr"
}
' "$input_file"

#czas zakończenia (dla użytkownika)
end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "Zakończono sukcesem konwersję $total_records rekordów w $duration s."
echo "Wynik zapisano w pliku \"$output_file\""
