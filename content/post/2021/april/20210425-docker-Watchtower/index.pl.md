+++
date = "2021-04-25T09:28:11+01:00"
title = "Krótka historia: Automatycznie aktualizuj kontenery za pomocą Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.pl.md"
+++
Jeśli uruchamiasz kontenery Docker na swojej stacji dysków, naturalnie chcesz, aby były one zawsze aktualne. Watchtower automatycznie aktualizuje obrazy i kontenery. Dzięki temu możesz korzystać z najnowszych funkcji i najbardziej aktualnych zabezpieczeń danych. Dzisiaj pokażę Wam jak zainstalować Watchtower na stacji dysków Synology.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy wejść w "Panel sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się poprzez "SSH", podany port i hasło administratora (użytkownicy Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się przez Terminal, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Zainstaluj Watchtower
Używam do tego konsoli:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Następnie Strażnica zawsze działa w tle.
{{< gallery match="images/3/*.png" >}}
