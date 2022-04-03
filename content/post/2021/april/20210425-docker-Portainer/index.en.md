+++
date = "2021-04-25T09:28:11+01:00"
title = "Great things with containers: Portainer as an alternative to Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.en.md"
+++

## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: create portainer folder
I create a new directory called "portainer" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Then I go to the portainer directory with the console and create a folder and a new file called "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Here is the content of the "portainer.yml" file:
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
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 3: Portainer start
I can also make good use of the console in this step. I start the portainer server via Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
After that I can call my Portainer server with the IP of the diskstation and the assigned port from "Step 2". I enter my admin password and choose the local variant.
{{< gallery match="images/4/*.png" >}}
As you can see, everything works great!
{{< gallery match="images/5/*.png" >}}
