+++
date = "2021-04-25T09:28:11+01:00"
title = "Scurtă poveste: Actualizarea automată a containerelor cu Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.ro.md"
+++
Dacă rulați containere Docker pe stația dumneavoastră de discuri, este normal să doriți ca acestea să fie mereu actualizate. Watchtower actualizează automat imaginile și containerele. În acest fel, vă puteți bucura de cele mai recente caracteristici și de cea mai recentă securitate a datelor. Astăzi vă voi arăta cum să instalați un Watchtower pe stația de discuri Synology.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Instalarea Watchtower
Eu folosesc consola pentru acest lucru:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
După aceea, Watchtower rulează întotdeauna în fundal.
{{< gallery match="images/3/*.png" >}}

