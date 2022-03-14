+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS on the Synology disk station"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.en.md"
+++
Bitwarden is a free, open-source password management service that stores sensitive information like website credentials in an encrypted vault. Today I'll show how to install a BitwardenRS on the Synology DiskStation.
## Step 1: Prepare BitwardenRS folder
I create a new directory called "bitwarden" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install BitwardenRS
I click on the "Registry" tab in the Synology Docker window and search for "bitwarden". I select the Docker image "bitwardenrs/server" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
I double click on my bitwardenrs image. After that I click on "Advanced Settings" and activate the "Automatic Restart" here as well.
{{< gallery match="images/3/*.png" >}}
I select the "Volume" tab and click on "Add Folder". There I create a new folder with this mount path "/data".
{{< gallery match="images/4/*.png" >}}
I assign fixed ports for the "bitwardenrs" container. Without fixed ports, it could be that the "bitwardenrs server" runs on a different port after a reboot. The first container port can be deleted. The other port should be remembered.
{{< gallery match="images/5/*.png" >}}
The container can now be started. I call the bitwardenrs server with the Synology IP address and my container port 8084.
{{< gallery match="images/6/*.png" >}}

## Step 3: Set up HTTPS
I click on "Control Panel" > "Reverse Proxy" and "Create".
{{< gallery match="images/7/*.png" >}}
After that I can call the bitwardenrs server with the Synology IP address and my proxy port 8085, encrypted.
{{< gallery match="images/8/*.png" >}}