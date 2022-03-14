+++
date = "2021-04-18"
title = "Store ting med containere: Kørsel af Docspell DMS på Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-Docspell/index.da.md"
+++
Docspell er et dokumenthåndteringssystem til Synology DiskStation. Med Docspell kan dokumenter indekseres, søges og findes meget hurtigere. I dag viser jeg, hvordan man installerer en Docspell-tjeneste på Synology diskstationen.
## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Opret Docspel-mappen
Jeg opretter en ny mappe med navnet "docspell" i Docker-mappen.
{{< gallery match="images/3/*.png" >}}
Nu skal følgende fil downloades og pakkes ud i mappen: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Jeg bruger konsollen til dette:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Derefter redigerer jeg filen "docker/docker-compose.yml" og indtaster mine Synology-adresser i "consumedir" og "db":
{{< gallery match="images/4/*.png" >}}
Herefter kan jeg starte Compose-filen:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Efter et par minutter kan jeg ringe til min Docspell-server med diskstationens IP-nummer og den tildelte port/7878.
{{< gallery match="images/5/*.png" >}}
