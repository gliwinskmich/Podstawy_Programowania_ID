#!/bin/bash

# Konfiguracja
FONT="/usr/share/fonts/Adwaita/AdwaitaSans-Regular.ttf" #można zmienić na dostępną czcionkę
FONT_SIZE=48
TEXT_PADDING=20
BORDER_COLOR="white"
OUTPUT_DIR="labeled_images"
INPUT_DIR="processed_images"

echo "***Uwaga, wykorzystywany jest font \"AdwaitaSans-Regular\" - w razie problemów należy zmienić [linia 4: FONT].***"

rm -rf "$OUTPUT_DIR" "$INPUT_DIR"
mkdir -p "$OUTPUT_DIR"
unzip -q processed_images.zip -d "$INPUT_DIR" || { echo "Błąd wypakowywania!"; exit 1; }

add_caption() {
local input="$1"
local output="$2"
local caption="$3"
local width=$(magick identify -format "%w" "$input")
#generowanie podpisów
magick -background "$BORDER_COLOR" -fill black \
-font "$FONT" -pointsize $FONT_SIZE \
-size ${width}x caption:"$caption" \
miff:- | \
magick "$input" - -append "$output"
}

#dodawanie podpisów obrazów przed dodaniem do PDF (z weryfikacją sukcesu)
echo "Dodawanie podpisów do obrazów..."
for img in "$INPUT_DIR"/*.jpg; do
[ ! -f "$img" ] && continue
filename=$(basename "$img")
echo "Przetwarzanie: $filename"

add_caption "$img" "$OUTPUT_DIR/labeled_$filename" "$filename" || {
echo "Błąd przy dodawaniu podpisu do $filename"
}
done

#generowanie PDF (tylko jeśli są przetworzone obrazy)
if [ -n "$(ls -A "$OUTPUT_DIR")" ]; then
echo "Tworzenie PDF..."
magick montage "$OUTPUT_DIR"/labeled_*.jpg \
-tile 2x4 -geometry +10+10 -page A4 \
-background "$BORDER_COLOR" \
-border 50x50 \
-bordercolor "$BORDER_COLOR" \
-density 150 \
portfolio.pdf
echo "PDF wygenerowany pomyślnie: portfolio.pdf"
else
echo "Brak przetworzonych obrazów do utworzenia PDF!"
exit 1
fi
#sprzątanie
rm -rf labeled_images
rm -rf processed_images