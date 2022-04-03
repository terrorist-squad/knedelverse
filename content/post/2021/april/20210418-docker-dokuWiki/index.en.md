+++
date = "2021-04-18"
title = "Great things with containers: Installing your own dokuWiki on Synology Diskstation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.en.md"
+++
DokuWiki is a standards-compliant, easy-to-use and at the same time extremely versatile open source wiki software. Today I show how to install a dokuWiki service on the Synology DiskStation.
## Option for professionals
Of course, as an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: Prepare wiki folder
I create a new directory named "wiki" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install DokuWiki
After that, a database needs to be created. I click on the "Registration" tab in the Synology Docker window and search for "dokuwiki". I select the Docker image "bitnami/dokuwiki" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.I double-click on my dokuwiki image.
{{< gallery match="images/3/*.png" >}}
I assign fixed ports for the "dokuwiki" container. Without fixed ports it could be that the "dokuwiki server" runs on another port after a restart.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What is it?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Time zone|
|DOKUWIKI_USERNAME	| admin|Admin username|
|DOKUWIKI_FULL_NAME |	wiki	|WIki name|
|DOKUWIKI_PASSWORD	| password	|Admin password|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/5/*.png" >}}
The container can now be started. I call the dokuWIki server with the Synology IP address and my container port.
{{< gallery match="images/6/*.png" >}}

