+++
date = "2020-02-13"
title = "Synology-Nas: Install Calibre Web as ebook library"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.en.md"
+++
How do I install Calibre-Web as a Docker container on my Synology NAS? Attention: This installation method is outdated and is not compatible with the current Calibre software. Please check out this new tutorial:[Great things with containers: running Calibre with Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Great things with containers: running Calibre with Docker Compose"). This tutorial is for all Synology DS professionals.
## Step 1: Create folder
First I create a folder for the Calibre library.  I call the "System Control" -> "Shared Folder" and create a new folder "Books".
{{< gallery match="images/1/*.png" >}}

##  Step 2: Create Calibre library
Now I copy an existing library or "[this empty sample library](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" into the new directory. I myself have copied the existing library of the desktop application.
{{< gallery match="images/2/*.png" >}}

## Step 3: Find Docker image
I click on the "Registry" tab in the Synology Docker window and search for "Calibre". I select the Docker image "janeczku/calibre-web" and then click on the tag "latest".
{{< gallery match="images/3/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.
## Step 4: Put the image into operation:
I double click on my Calibre image.
{{< gallery match="images/4/*.png" >}}
After that I click on "Advanced Settings" and activate the "Automatic Restart". I select the tab "Volume" and click on "Add Folder". There I create a new database folder with this mount path "/calibre".
{{< gallery match="images/5/*.png" >}}
I assign fixed ports for the Calibre container. Without fixed ports it could be that Calibre runs on a different port after a reboot.
{{< gallery match="images/6/*.png" >}}
After these settings Calibre can be started!
{{< gallery match="images/7/*.png" >}}
I now call my Synology IP with the assigned Calibre port and see the following picture. I specify "/calibre" as the "Location of Calibre Database". The rest of the settings are a matter of taste.
{{< gallery match="images/8/*.png" >}}
The default login is "admin" with password "admin123".
{{< gallery match="images/9/*.png" >}}
Done! Of course, now I can also connect the desktop app via my "book folder". I swap the library in my app and then select my Nas folder.
{{< gallery match="images/10/*.png" >}}
Like this:
{{< gallery match="images/11/*.png" >}}
Now when I edit meta info in the desktop app, it is automatically updated in the web app as well.
{{< gallery match="images/12/*.png" >}}