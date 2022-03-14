+++
date = "2021-04-25T09:28:11+01:00"
title = "Suuria asioita konttien kanssa: Portainer vaihtoehtona Synology Docker GUI:lle"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Portainer/index.fi.md"
+++

## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Luo portainer-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "portainer".
{{< gallery match="images/3/*.png" >}}
Sitten menen konsolin avulla portainer-hakemistoon ja luon sinne kansion ja uuden tiedoston nimeltä "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Tässä on "portainer.yml"-tiedoston sisältö:
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 3: Säiliön käynnistäminen
Voin myös hyödyntää konsolia tässä vaiheessa. Käynnistän porttipalvelimen Docker Composen kautta.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Sitten voin kutsua Portainer-palvelimeni levyaseman IP-osoitteella ja vaiheessa 2 määritetyllä portilla. Syötän järjestelmänvalvojan salasanan ja valitsen paikallisen vaihtoehdon.
{{< gallery match="images/4/*.png" >}}
Kuten näet, kaikki toimii hienosti!
{{< gallery match="images/5/*.png" >}}