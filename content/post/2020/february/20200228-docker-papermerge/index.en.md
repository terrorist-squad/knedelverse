+++
date = "2020-02-28"
title = "Great things with containers: Running Papermerge DMS on a Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.en.md"
+++
Papermerge is a young document management system (DMS) that can automatically assign and process documents. In this tutorial I show you how I installed Papermerge on my Synology Diskstation and how the DMS works.
## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Step 1: Create folder
First, I create a folder for the paper merge. I call the "System control" -> "Shared folder" and create a new folder "Document archive".
{{< gallery match="images/1/*.png" >}}
Step 2: Find Docker imageIn the Synology Docker window, I click on the "Registry" tab and search for "Papermerge". I select the Docker image "linuxserver/papermerge" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.
## Step 3: Put the image into operation:
I double click on my paper merge image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the tab "Volume" and click on "Add Folder". There I create a new database folder with this mount path "/data".
{{< gallery match="images/4/*.png" >}}
In addition, I store here a second folder that I include with the mount path "/config". Where this is actually does not matter. However, it is important that this belongs to the Synology admin user.
{{< gallery match="images/5/*.png" >}}
I assign fixed ports for the "Papermerge" container. Without fixed ports it could happen that the "Papermerge-Server" runs on another port after a reboot.
{{< gallery match="images/6/*.png" >}}
Finally, I enter three environment variables. The variable "PUID" is the user ID and "PGID" the group ID of my admin user. You can find out the PGID/PUID via SSH with the command "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
After these settings the Papermerge server can be started! After that, you can call Papermerge via the Ip address of the Synology disctation and the assigned port, for example http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
The default login is admin with password admin.
## How does Papermerge work?
Papermerge analyzes the text of documents and images. Papermerge uses an OCR/"optical character recognition" library called tesseract, published by Goolge.
{{< gallery match="images/9/*.png" >}}
I created a folder called "Everything with Lorem" to test the automatic document assignment. After that, I clicked together a new recognition pattern in the menu item "Automates".
{{< gallery match="images/10/*.png" >}}
All new documents that contain the word "Lorem" will be placed in the folder "Everything with Lorem" and tagged with "has-lorem". It is important to use a comma in the tags. If you upload a document, it will be tagged and sorted.
{{< gallery match="images/11/*.png" >}}