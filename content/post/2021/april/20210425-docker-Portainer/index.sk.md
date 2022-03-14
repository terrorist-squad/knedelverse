+++
date = "2021-04-25T09:28:11+01:00"
title = "Skvelé veci s kontajnermi: Portainer ako alternatíva ku grafickému rozhraniu Synology Docker"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Portainer/index.sk.md"
+++

## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Vytvorenie priečinka portainer
V adresári Docker vytvorím nový adresár s názvom "portainer".
{{< gallery match="images/3/*.png" >}}
Potom prejdem do adresára portainer pomocou konzoly a vytvorím tam priečinok a nový súbor s názvom "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Tu je obsah súboru "portainer.yml":
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
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 3: Spustenie zásobníka
V tomto kroku môžem tiež dobre využiť konzolu. Spustím server portainer prostredníctvom nástroja Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Potom môžem zavolať svoj server Portainer pomocou IP adresy diskovej stanice a priradeného portu z kroku 2. Zadám heslo správcu a vyberiem miestny variant.
{{< gallery match="images/4/*.png" >}}
Ako vidíte, všetko funguje skvele!
{{< gallery match="images/5/*.png" >}}