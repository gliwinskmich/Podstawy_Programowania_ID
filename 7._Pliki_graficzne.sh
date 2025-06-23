#!/bin/bash

#konfiguracja
input_dir="$(pwd)"
output_dir="${input_dir}/output_images"
temp_dir="${input_dir}/temp_extract"
final_archive="${input_dir}/processed_images.zip"
target_height=720
target_dpi="96x96"

echo "Zmiana formatu i rozdzielczości spakowanych plików graficznych"
echo ""
echo "***Uwaga, skrypt korzysta z pakietów: zip, unzip, imagemagick***"
echo ""

#tworzenie katalogów roboczych
mkdir -p "${output_dir}" "${temp_dir}"
echo "> utworzono katalogi robocze"

#rozpakowywanie wszystkich archiwów ZIP (również zagnieżdżonych)
find "${input_dir}" -type f -name '*.zip' -exec unzip -q -o -d "${temp_dir}" {} \;
echo "> znaleziono i rozpakowano wszystkie archiwa"
echo "> rozpoczęto konwersję obrazów..."
while IFS= read -r -d '' image; do

#określanie nazwy pliku wyjściowego z rozszerzeniem .jpg
output_filename="${output_dir}/$(basename "${image%.*}").jpg"

#konwersja obrazu
magick "${image}" \
-resize "x${target_height}" \
-set units PixelsPerInch \
-density "${target_dpi}" \
"${output_filename}"
done < <(find "${temp_dir}" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.bmp' \) -print0)
echo "> rozpoczęto dodawanie obrazów do archiwum..."

#pakowanie gotowych obrazów
if [ -n "$(ls -A "${output_dir}")" ]; then
    zip -q -jr "${final_archive}" "${output_dir}"/*
else
    echo "Błąd. Brak plików graficznych do spakowania."
fi

#sprzątanie
echo "> sprzątanie..."
rm -rf "${temp_dir}"
rm -rf output_images
echo "> zakończono"

#lokalizacja nowego archiwum
echo "Gotowe archiwum dostępne w lokalizacji: ${final_archive}"