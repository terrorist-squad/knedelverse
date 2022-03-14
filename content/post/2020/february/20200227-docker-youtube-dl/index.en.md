+++
date = "2020-02-27"
title = "Great things with containers: Running Youtube downloader on Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.en.md"
+++
Many of my friends know that I run a private learning video portal on my Homelab - Network. I have saved video courses from past learning portal memberships and good youtube tutorials for offline use on my NAS.
{{< gallery match="images/1/*.png" >}}
Over time, I have collected 8845 video courses with 282616 individual videos. The total running time is equivalent to about 2 years. Absolutely crazy!In this tutorial I show how to backup good youtube tutorials with a docker download service for offline purposes.
## Option for professionals
As an experienced Synology user, you can of course log in with SSH and install the whole setup via Docker Compose file.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Step 1
First I create a folder for the downloads. I call the "System Control" -> "Shared Folder" and create a new folder "Downloads".
{{< gallery match="images/2/*.png" >}}

## Step 2: Find Docker image
I click on the "Registration" tab in the Synology Docker window and search for "youtube-dl-nas". I select the Docker image "modenaf360/youtube-dl-nas" and then click on the tag "latest".
{{< gallery match="images/3/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.
## Step 3: Put the image into operation:
I double click on my youtube-dl-nas image.
{{< gallery match="images/4/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the tab "Volume" and click on "Add Folder". There I create a new database folder with this mount path "/downfolder".
{{< gallery match="images/5/*.png" >}}
I assign fixed ports for the "Youtube Downloader" container. Without fixed ports it could be that the "Youtube-Downloader" runs on another port after a reboot.
{{< gallery match="images/6/*.png" >}}
Finally, I enter two environment variables. The variable "MY_ID" is my username and "MY_PW" is my password.
{{< gallery match="images/7/*.png" >}}
After these settings Downloader can be started! After that you can call the downloader via the Ip-address of the Synology-disktation and the assigned port, for example http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
For authentication, take the username and password from MY_ID and MY_PW.
## Step 4: Let's go
Now Youtube video urls and playlist urls can be entered into "URL" field and all videos will automatically end up in the download folder of Synology DiskStation.
{{< gallery match="images/9/*.png" >}}
Download Folder:
{{< gallery match="images/10/*.png" >}}