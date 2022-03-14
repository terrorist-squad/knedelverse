+++
date = "2020-02-13"
title = "Synology-Nas: Confluence as Wiki System"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.en.md"
+++
If you want to install Atlassian Confluence on a Synology NAS, you've come to the right place.
## Step 1
First, I open the Docker app in the Synology interface and then go to the sub-item "Registration". There I search for "Confluence" and click on the first image "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Step 2
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.
## Automatic restart
I double click on my Confluence image.
{{< gallery match="images/2/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart".
{{< gallery match="images/3/*.png" >}}

## Ports
I assign fixed ports for the Confluence container. Without fixed ports it could happen that Confluence runs on a different port after a restart.
{{< gallery match="images/4/*.png" >}}

## Memory
I create a physical folder and mount it in the container (/var/atlassian/application-data/confluence/). This setting makes backing up and restoring data easier.
{{< gallery match="images/5/*.png" >}}
After these settings Confluence can be started!
{{< gallery match="images/6/*.png" >}}