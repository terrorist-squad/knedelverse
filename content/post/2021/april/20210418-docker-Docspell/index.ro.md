+++
date = "2021-04-18"
title = "Lucruri grozave cu containere: Rularea Docspell DMS pe Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.ro.md"
+++
Docspell este un sistem de gestionare a documentelor pentru Synology DiskStation. Prin intermediul Docspell, documentele pot fi indexate, căutate și găsite mult mai rapid. Astăzi vă arăt cum să instalați un serviciu Docspell pe stația de discuri Synology.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Creați dosarul Docspel
Creez un nou director numit "docspell" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Acum, următorul fișier trebuie descărcat și despachetat în directorul: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Eu folosesc consola pentru acest lucru:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Apoi, editez fișierul "docker/docker-compose.yml" și introduc adresele Synology în "consumedir" și "db":
{{< gallery match="images/4/*.png" >}}
După aceea, pot să pornesc fișierul Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
După câteva minute, pot apela serverul meu Docspell cu IP-ul stației de disc și portul alocat/7878.
{{< gallery match="images/5/*.png" >}}
