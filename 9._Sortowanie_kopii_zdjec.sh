#!/bin/bash

MAIN_DIR="kopie"
mkdir -p "$MAIN_DIR"

organizuj_pliki() {
local zip_plik="$1"

TEMP_DIR="temp_unzip"
mkdir -p "$TEMP_DIR"

unzip -q "$zip_plik" -d "$TEMP_DIR"

for plik in "$TEMP_DIR"/*.zip; do
local nazwa_pliku=$(basename "$plik")

if [[ $nazwa_pliku =~ ^([0-9]{4})-([0-9]{2})-[0-9]{2}\.zip$ ]]; then
local rok="${BASH_REMATCH[1]}"
local miesiac="${BASH_REMATCH[2]}"

local docelowy_dir="$MAIN_DIR/$rok/$miesiac"
mkdir -p "$docelowy_dir"

mv "$plik" "$docelowy_dir/"
#gdy pojawi się niepasująca nazwa, zostanie pominięta
else
echo "Ostrzeżenie: Plik $nazwa_pliku nie pasuje do wzorca nazwy. Pomijanie."
fi
done

rm -rf "$TEMP_DIR"
}

organizuj_pliki "kopie-1.zip"
organizuj_pliki "kopie-2.zip"

echo "Pliki zostały zorganizowane w folderze $MAIN_DIR"
