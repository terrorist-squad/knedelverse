+++
date = "2020-02-21"
title = "Great things with containers: Running Calibre with Docker Compose (Synology pro setup)."
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.en.md"
+++
There is already a simpler tutorial on this blog: [Synology-Nas: Install Calibre Web as ebook library]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Install Calibre Web as ebook library"). This tutorial is for all Synology DS professionals.
## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Create books folder
I create a new folder for the Calibre library. To do this, I go to "Control Panel" -> "Shared Folder" and create a new folder called "Books". If there is no "Docker" folder yet, then this must also be created.
{{< gallery match="images/3/*.png" >}}

## Step 3: Prepare books folder
Now the following file must be downloaded and unpacked: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. The content ("metadata.db") must be placed in the new books directory, see:
{{< gallery match="images/4/*.png" >}}

## Step 4: Prepare Docker folder
I create a new directory called "calibre" in the Docker directory:
{{< gallery match="images/5/*.png" >}}
Then I change to the new directory and create a new file called "calibre.yml" with the following content:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
In this new file several places must be adjusted as follows:* PUID/PGID: In PUID/PGID the user and group ID of the DS user must be entered. Here I use the console from "Step 1" and the commands "id -u" to see the user ID. With the command "id -g" I get the group ID.* ports: At the port the front part "8055:" must be adjusted.directoriesAll directories in this file must be corrected. The correct addresses can be seen in the properties window of the DS. (Screenshot follows)
{{< gallery match="images/6/*.png" >}}

## Step 5: Test start
I can also make good use of the console in this step. I change to the Calibre directory and start the Calibre server there via Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Step 6: Setup
After that I can call my Calibre server with the IP of the diskstation and the assigned port from "Step 4". In the setup I use my "/books" mountpoint. After that the server is already usable.
{{< gallery match="images/8/*.png" >}}

## Step 7: Finalizing the setup
Also in this step the console is needed. I use the "exec" command to save the container-internal application database.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
After that I see a new "app.db" file in the Calibre directory:
{{< gallery match="images/9/*.png" >}}
I then stop the Calibre server:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Now I change the letterbox path and persist the application database over it.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
After that, the server can be restarted:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
