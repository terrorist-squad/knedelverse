+++
date = "2022-03-21"
title = "Great things with containers: record MP3s from the radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.en.md"
+++
Streamripper is a command line tool that allows you to record MP3 or OGG/Vorbis streams and save them directly to your hard disk. The songs are automatically named after the artist and saved individually, the format is the one originally sent (so in effect, files with the extension .mp3 or .ogg are created). I found a great radiorecorder interface and built a Docker image from it, see: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Option for professionals
Of course, as an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Step 1: Find Docker image
I click on the "Registration" tab in the Synology Docker window and search for "mighty-mixxx-tapper". I select the Docker image "chrisknedel/mighty-mixxx-tapper" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image/image (fixed state). Before we now create a container from the image, a few settings must be made.
## Step 2: Put image/image into operation:
I double-click on my mighty-mixxx-tapper image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the "Volume" tab and click on "Add Folder". There I create a new folder with this mount path "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
I assign fixed ports for the "mighty-mixxx-tapper" container. Without fixed ports it could be that the "mighty-mixxx-tapper-server" runs on another port after a reboot.
{{< gallery match="images/5/*.png" >}}
After these settings mighty-mixxx-tapper-server can be started! After that you can call mighty-mixxx-tapper via the Ip address of the Synology disktation and the assigned port, for example http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
