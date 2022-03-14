+++
date = "2021-03-07"
title = "Wspaniałe rzeczy z kontenerami: zarządzanie i archiwizowanie przepisów na stacji Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-docker-mealie/index.pl.md"
+++
Zbierz wszystkie swoje ulubione przepisy w kontenerze Docker i zorganizuj je tak, jak chcesz. Pisz własne przepisy lub importuj przepisy z serwisów internetowych, np. "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Krok 1: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mealie". Wybieram obraz Docker "hkotel/mealie:latest", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz/image (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 2: Wprowadź obraz do działania:
Klikam dwukrotnie na mój obrazek "mealie".
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder z tą ścieżką montowania "/app/data".
{{< gallery match="images/4/*.png" >}}
Przypisuję stałe porty dla kontenera "Mealie". Bez ustalonych portów może się zdarzyć, że "serwer Mealie" po restarcie działa na innym porcie.
{{< gallery match="images/5/*.png" >}}
Na koniec wprowadzam dwie zmienne środowiskowe. Zmienna "db_type" jest typem bazy danych, a "TZ" jest strefą czasową "Europa/Berlin".
{{< gallery match="images/6/*.png" >}}
Po tych ustawieniach można uruchomić Mealie Server! Następnie można połączyć się z Mealie za pośrednictwem adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Jak działa Mealie?
Jeśli najadę myszką na przycisk "Plus" po prawej/dolnej stronie, a następnie kliknę na symbol "łańcuszka", mogę wpisać adres url. Następnie aplikacja Mealie automatycznie wyszukuje wymagane informacje meta i schema.
{{< gallery match="images/8/*.png" >}}
Import działa świetnie (użyłem tych funkcji z adresami URL z Chef, Food
{{< gallery match="images/9/*.png" >}}
W trybie edycji, mogę również dodać kategorię. Ważne jest, aby po każdej kategorii nacisnąć raz klawisz "Enter". W przeciwnym razie ustawienie to nie jest stosowane.
{{< gallery match="images/10/*.png" >}}

## Cechy szczególne
Zauważyłem, że kategorie menu nie aktualizują się automatycznie. Musisz pomóc tutaj z przeładowaniem przeglądarki.
{{< gallery match="images/11/*.png" >}}

## Inne cechy
Oczywiście, można wyszukiwać przepisy, a także tworzyć menu. Ponadto, można bardzo szeroko dostosować "Mealie".
{{< gallery match="images/12/*.png" >}}
Mealie świetnie prezentuje się również na urządzeniach mobilnych:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Dokumentację API można znaleźć pod adresem "http://gewaehlte-ip:und-port ... /docs". Tutaj znajdziesz wiele metod, które mogą być wykorzystane do automatyzacji.
{{< gallery match="images/14/*.png" >}}

## Przykład Api
Wyobraźmy sobie następującą fikcję: "Gruner und Jahr uruchamia portal internetowy Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Następnie wyczyść tę listę i odpal ją przeciwko api reszty, przykład:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Teraz możesz mieć dostęp do przepisów również w trybie offline:
{{< gallery match="images/15/*.png" >}}
