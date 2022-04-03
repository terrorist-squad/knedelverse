+++
date = "2020-02-13"
title = "Synology-Nas: Confluence jako system wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.pl.md"
+++
Jeśli chcesz zainstalować Atlassian Confluence na serwerze NAS firmy Synology, to jesteś we właściwym miejscu.
## Krok 1
Najpierw otwieram aplikację Docker w interfejsie Synology, a następnie przechodzę do podpunktu "Rejestracja". Wyszukuję tam hasło "Confluence" i klikam na pierwszy obrazek "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Krok 2
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz/obraz (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Automatyczny restart
Klikam dwukrotnie na obraz Confluence.
{{< gallery match="images/2/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/3/*.png" >}}

## Porty
Przydzielam stałe porty dla kontenera Confluence. Bez stałych portów Confluence może działać na innym porcie po ponownym uruchomieniu.
{{< gallery match="images/4/*.png" >}}

## Pamięć
Tworzę folder fizyczny i montuję go w kontenerze (/var/atlassian/application-data/confluence/). To ustawienie ułatwia tworzenie kopii zapasowych i przywracanie danych.
{{< gallery match="images/5/*.png" >}}
Po wprowadzeniu tych ustawień można uruchomić Confluence!
{{< gallery match="images/6/*.png" >}}
