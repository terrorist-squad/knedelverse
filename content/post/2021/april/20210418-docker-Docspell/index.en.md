+++
date = "2021-04-18"
title = "Great things with containers: running Docspell DMS on Synology disk station"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.en.md"
+++
Docspell is a document management system for Synology DiskStation. Through Docspell documents can be indexed, searched and found much faster. Today I will show how to install a Docspell service on the Synology disk station.
## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Create Docspel folder
I create a new directory called "docspell" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Now the following file must be downloaded and unpacked in the directory: https://github.com/eikek/docspell/archive/refs/heads/master.zip . I use the console for this:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Then I edit the "docker/docker-compose.yml" file and enter my Synology addresses there at "consumedir" and "db":
{{< gallery match="images/4/*.png" >}}
After that I can start the Compose file:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
After a few minutes I can call my Docspell server with the IP of the disk station and the assigned port/7878.
{{< gallery match="images/5/*.png" >}}
The search for documents works well. I find it a pity that the texts in images are not indexed. At Papermerge you can also search for texts in images.
