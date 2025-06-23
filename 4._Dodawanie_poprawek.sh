#!/bin/bash

#sprawdzenie czy docelowe pliki istnieją
sprawdz_pliki() {
    if [ ! -f "lista.txt" ]; then
        echo "Błąd: brak pliku 'lista.txt'"
        exit 1
    fi

    if [ ! -f "lista-pop.txt" ]; then
        echo "Błąd: brak pliku 'lista-pop.txt'"
        exit 1
    fi
}

#porównanie zawartości plików
porownaj_pliki() {
    echo -e "\n\nRóżnice między pierwotną listą a listą z poprawkami:"
    echo -e "\n> słowa występujące wyłącznie w pierwotnej liście (lista.txt):"
    comm -23 <(sort lista.txt) <(sort lista-pop.txt)
    echo -e "\n> słowa występujące wyłącznie w zaktualizowanej liście (lista-pop.txt):"
    comm -13 <(sort lista.txt) <(sort lista-pop.txt)
    echo ""
}

#aktualizowanie pliku
aktualizuj_plik() {
    read -p "Czy zaktualizować treść listy (lista.txt) poprawkami (lista-pop.txt)? [T/N]: " odpowiedz
    if [[ "$odpowiedz" =~ [Tt] ]]; then
        cp -f lista-pop.txt lista.txt
        echo -e "\n> lista została zaktualizowana.\n  Aby w przyszłości ręcznie aktualizować listę, należy wykonać polecenie:\n  $ cp lista-pop.txt lista.txt"
        else
        echo -e "\n> anulowano aktualizację, lista pozostaje bez zmian.\n  Aby ręcznie zaktualizować listę, należy wykonać polecenie:\n  $ cp lista-pop.txt lista.txt"
        echo ""
        echo -e "########## Operacja zakończona ##########"
        echo ""
        exit 0
    fi
}

#weryfikacja sumy MD5
weryfikuj_md5() {
    echo -e "\nWeryfikacja sum kontrolnych (MD5):"
    echo ""

    md5_lista=$(md5sum lista.txt | awk '{print $1}')
    md5_pop=$(md5sum lista-pop.txt | awk '{print $1}')

    echo "> lista po aktualizacji: $md5_lista"
    echo "> lista poprawek: $md5_pop"

    if [ "$md5_lista" == "$md5_pop" ]; then
        echo -e "\nSumy MD5 są identyczne - pliki są takie same"
    else
        echo -e "\nSumy MD5 są różne - pliki się różnią"
    fi
}

#główna część skryptu
clear
echo ""
echo "########## Dodawanie poprawek do listy słów ##########"

sprawdz_pliki

porownaj_pliki

aktualizuj_plik

weryfikuj_md5
echo ""
echo -e "########## Operacja zakończona ##########"
echo ""
exit 0
