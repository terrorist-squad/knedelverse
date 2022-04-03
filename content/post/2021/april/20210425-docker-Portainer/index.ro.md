+++
date = "2021-04-25T09:28:11+01:00"
title = "Lucruri grozave cu containere: Portainer ca o alternativă la Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.ro.md"
+++

## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Creați dosarul portainer
Creez un nou director numit "portainer" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Apoi mă duc în directorul portainer cu consola și creez acolo un dosar și un nou fișier numit "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Iată conținutul fișierului "portainer.yml":
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 3: Pornirea porțelanului
De asemenea, în această etapă pot utiliza consola. Pornesc serverul Portainer prin Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Apoi, pot apela serverul Portainer cu IP-ul stației de disc și portul atribuit de la "Pasul 2". Introduc parola mea de administrator și selectez varianta locală.
{{< gallery match="images/4/*.png" >}}
După cum puteți vedea, totul funcționează foarte bine!
{{< gallery match="images/5/*.png" >}}
