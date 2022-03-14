+++
date = "2021-04-25T09:28:11+01:00"
title = "Rövid történet: Konténerek automatikus frissítése Watchtowerrel"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.hu.md"
+++
Ha Docker-konténereket futtat a lemezállomásán, természetesen azt szeretné, hogy azok mindig naprakészek legyenek. A Watchtower automatikusan frissíti a képeket és a konténereket. Így élvezheti a legújabb funkciókat és a legmodernebb adatbiztonságot. Ma megmutatom, hogyan kell telepíteni egy Watchtower-t a Synology lemezállomásra.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Watchtower telepítése
Ehhez a konzolt használom:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Ezután az Őrtorony mindig a háttérben fut.
{{< gallery match="images/3/*.png" >}}
