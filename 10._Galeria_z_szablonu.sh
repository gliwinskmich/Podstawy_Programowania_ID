#!/bin/bash

GALLERY_DIR="galeria2"
OUTPUT_FILE="index2.html"
TEMPLATE_FILE="galeria/index.html"

echo "W katalogu musi znajdować się archiwum z zad. 7 (wygenerowane skryptem z zad. 7 - processed_images.zip) oraz archiwum galeria.zip"

#czy istnieją wymagane pliki zip
if [ ! -f "processed_images.zip" ]; then
echo "Brak pliku processed_images.zip w bieżącym katalogu!"
exit 1
fi

if [ ! -f "galeria.zip" ]; then
echo "Brak pliku galeria.zip w bieżącym katalogu!"
exit 1
fi

#unzip
unzip -n processed_images.zip -d "$GALLERY_DIR"
unzip -n galeria.zip -d "galeria"

if [ ! -f "$TEMPLATE_FILE" ]; then
echo "Brak pliku szablonu $TEMPLATE_FILE!"
exit 1
fi

#marker do wstawienia kodu (wykorzystano komentarz przed pierwszą grafiką z index.html aby nie dublować grafik)
if ! grep -q "<!-- plik 1: \"blue.png\" -->" "$TEMPLATE_FILE"; then
echo "Błąd: Szablon musi zawierać marker <!-- plik 1: \"blue.png\" -->"
exit 1
fi

#generowanie galerii w pliku wynikowym
awk '
/<!-- plik 1: "blue.png" -->/ {
# Wstaw sekcję z grafikami przed markerem
cmd = "find \"'"$GALLERY_DIR"'\" -type f \\( -iname \"*.png\" -o -iname \"*.jpg\" -o -iname \"*.jpeg\" -o -iname \"*.gif\" \\) | sort"
while ((cmd | getline image) > 0) {
filename = gensub(".*/", "", "g", image)
relative_path = "'"$GALLERY_DIR"'/" filename

print "\n<!-- plik: \"" relative_path "\" -->"
print "<div class=\"responsive\">"
print " <div class=\"gallery\">"
print " <a target=\"_blank\" href=\"" relative_path "\">"
print " <img src=\"" relative_path "\">"
print " </a>"
print " <div class=\"desc\">" filename "</div>"
print " </div>"
print "</div>"
}
close(cmd)
next
}
{ print }
' "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo ""
echo "Plik $OUTPUT_FILE został utworzony zgodnie z szablonem."
echo "Grafiki do pliku $OUTPUT_FILE znajdują się w folderze $GALLERY_DIR."
echo ""
