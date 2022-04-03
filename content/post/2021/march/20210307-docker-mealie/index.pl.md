+++
date = "2021-03-07"
title = "Wspaniałe rzeczy dzięki kontenerom: zarządzanie przepisami kulinarnymi i ich archiwizowanie na stacji Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.pl.md"
+++
Zbierz wszystkie swoje ulubione przepisy w kontenerze Docker i zorganizuj je tak, jak chcesz. Pisz własne przepisy lub importuj przepisy z witryn internetowych, na przykład "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
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
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mealie". Wybieram obraz Dockera "hkotel/mealie:latest", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz/obraz (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 2: Uruchomienie obrazu:
Klikam dwukrotnie obraz "mealie".
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/app/data".
{{< gallery match="images/4/*.png" >}}
Kontenerowi "Mealie" przydzielam stałe porty. Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer Mealie" będzie działał na innym porcie.
{{< gallery match="images/5/*.png" >}}
Na koniec wprowadzam dwie zmienne środowiskowe. Zmienna "db_type" to typ bazy danych, a "TZ" to strefa czasowa "Europa/Berlin".
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień można uruchomić serwer Mealie! Następnie można połączyć się z Mealie za pomocą adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Jak działa Mealie?
Jeśli przesunę kursor myszy nad przycisk "Plus" po prawej stronie/dolnej stronie, a następnie kliknę symbol "łańcucha", będę mógł wprowadzić adres url. Następnie aplikacja Mealie automatycznie wyszukuje wymagane informacje meta i schematy.
{{< gallery match="images/8/*.png" >}}
Import działa świetnie (użyłem tych funkcji z adresami URL z Chef, Food
{{< gallery match="images/9/*.png" >}}
W trybie edycji można również dodać kategorię. Ważne jest, aby po każdej kategorii raz nacisnąć klawisz "Enter". W przeciwnym razie to ustawienie nie jest stosowane.
{{< gallery match="images/10/*.png" >}}

## Cechy szczególne
Zauważyłem, że kategorie menu nie są aktualizowane automatycznie. W tym celu należy przeładować przeglądarkę.
{{< gallery match="images/11/*.png" >}}

## Inne cechy
Oczywiście można wyszukiwać przepisy, a także tworzyć jadłospisy. Ponadto program "Mealie" można w bardzo szerokim zakresie dostosować do własnych potrzeb.
{{< gallery match="images/12/*.png" >}}
Mealie doskonale prezentuje się również na urządzeniach mobilnych:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Dokumentację interfejsu API można znaleźć pod adresem "http://gewaehlte-ip:und-port ... /docs". Znajdziesz tu wiele metod, które można wykorzystać do automatyzacji.
{{< gallery match="images/14/*.png" >}}

## Przykład Api
Wyobraźmy sobie następującą fikcję: "Gruner und Jahr uruchamia portal internetowy Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Następnie wyczyść tę listę i odpal ją w api odpoczynku, np:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Teraz możesz korzystać z przepisów także w trybie offline:
{{< gallery match="images/15/*.png" >}}
Wniosek: Jeśli poświęcisz Mealie trochę czasu, możesz stworzyć wspaniałą bazę przepisów! Program Mealie jest stale rozwijany jako projekt open source i można go znaleźć pod następującym adresem: https://github.com/hay-kot/mealie/
