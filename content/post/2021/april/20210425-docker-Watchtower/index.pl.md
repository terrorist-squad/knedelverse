+++
date = "2021-04-25T09:28:11+01:00"
title = "Krótka historia: Automatycznie aktualizuj kontenery za pomocą Strażnicy"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.pl.md"
+++
Jeśli na swojej stacji dysków uruchamiasz kontenery Docker, naturalnie chcesz, aby były one zawsze aktualne. Watchtower automatycznie aktualizuje obrazy i kontenery. Dzięki temu można korzystać z najnowszych funkcji i najbardziej aktualnych zabezpieczeń danych. Dzisiaj pokażę, jak zainstalować wieżę strażniczą na stacji dysków Synology.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Zainstaluj Watchtower
Używam do tego konsoli:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Następnie Strażnica zawsze działa w tle.
{{< gallery match="images/3/*.png" >}}

