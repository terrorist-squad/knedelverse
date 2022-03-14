+++
date = "2021-04-18"
title = "Great things with containers: Running Docspell DMS on Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.en.md"
+++
Docspell is a document management system for the Synology DiskStation. Through Docspell, documents can be indexed, searched and found much faster. Today I will show how to install a Docspell service on the Synology DiskStation.
## Step 1: Prepare Synology
First of all, you need to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the given port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Create Docspel folder
I create a new directory called "docspell" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Now you need to download the following file and unzip it in the directory: https://github.com/eikek/docspell/archive/refs/heads/master.zip . I use the console for this:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Then I edit the "docker/docker-compose.yml" file and enter my Synology addresses there at "consumedir" and "db":
{{< gallery match="images/4/*.png" >}}
After that I can start the compose file:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
After a few minutes I can access my docspell server with the IP of the diskstation and the assigned port/7878.
{{< gallery match="images/5/*.png" >}}
