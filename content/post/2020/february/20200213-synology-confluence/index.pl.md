+++
date = "2020-02-13"
title = "Synology-Nas: Confluence jako system wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.pl.md"
+++
Jeśli chcesz zainstalować Atlassian Confluence na serwerze NAS firmy Synology, to trafiłeś we właściwe miejsce.
## Krok 1
Najpierw otwieram aplikację Docker w interfejsie Synology, a następnie przechodzę do podpunktu "Rejestracja". Tam wyszukuję "Confluence" i klikam na pierwszy obrazek "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Krok 2
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz/image (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Automatyczny restart
Klikam dwukrotnie na mój obraz Confluence.
{{< gallery match="images/2/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart".
{{< gallery match="images/3/*.png" >}}

## Porty
Przydzielam stałe porty dla kontenera Confluence. Bez ustalonych portów, Confluence może działać na innym porcie po ponownym uruchomieniu.
{{< gallery match="images/4/*.png" >}}

## Pamięć
Tworzę fizyczny folder i montuję go w kontenerze (/var/atlassian/application-data/confluence/). To ustawienie ułatwia tworzenie kopii zapasowych i przywracanie danych.
{{< gallery match="images/5/*.png" >}}
Po tych ustawieniach Confluence może zostać uruchomiony!
{{< gallery match="images/6/*.png" >}}