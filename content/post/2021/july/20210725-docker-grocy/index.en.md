+++
date = "2021-07-25"
title = "Great things with containers: refrigerator management with Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.en.md"
+++
With Grocy you can manage a whole household, restaurant, cafe, bistro or food market. You can manage refrigerators, menus, task, shopping lists and the shelf life of food.
{{< gallery match="images/1/*.png" >}}
Today I show how to install a Grocy service on the Synology disk station.
## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: Prepare Grocy folder
I create a new directory called "grocy" in the Docker directory.
{{< gallery match="images/2/*.png" >}}

## Step 2: Install Grocy
I click on the "Registry" tab in the Synology Docker window and search for "Grocy". I select the Docker image "linuxserver/grocy:latest" and then click on the tag "latest".
{{< gallery match="images/3/*.png" >}}
I double click on my Grocy image.
{{< gallery match="images/4/*.png" >}}
After that I click on "Advanced Settings" and activate the "Automatic Restart" here as well. I select the tab "Volume" and click on "Add Folder". There I create a new folder with this mount path "/config".
{{< gallery match="images/5/*.png" >}}
I assign fixed ports for the "Grocy" container. Without fixed ports it could be that the "Grocy-Server" runs on another port after a reboot.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What's that?|
|--- | --- |---|
|TZ | Europe/Berlin |Time zone|
|PUID | 1024 |User ID from Synology Admin User|
|PGID |	100 |Group ID from Synology Admin User|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/7/*.png" >}}
The container can now be started. I call the Grocy server with the Synology IP address and my container port and log in with the username "admin" and the password "admin".
{{< gallery match="images/8/*.png" >}}
