+++
date = "2021-04-25T09:28:11+01:00"
title = "Skvělé věci s kontejnery: Portainer jako alternativa ke grafickému uživatelskému rozhraní Synology Docker"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.cs.md"
+++

## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Vytvoření složky portainer
V adresáři Docker vytvořím nový adresář s názvem "portainer".
{{< gallery match="images/3/*.png" >}}
Pak přejdu do adresáře portainer pomocí konzoly a vytvořím v něm složku a nový soubor s názvem "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Zde je obsah souboru "portainer.yml":
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 3: Spuštění zásobníku
V tomto kroku mohu také dobře využít konzolu. Spouštím server portainer pomocí nástroje Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Pak mohu zavolat svůj server Portainer pomocí IP adresy diskové stanice a přiřazeného portu z kroku 2. Zadám heslo správce a vyberu místní variantu.
{{< gallery match="images/4/*.png" >}}
Jak vidíte, vše funguje skvěle!
{{< gallery match="images/5/*.png" >}}