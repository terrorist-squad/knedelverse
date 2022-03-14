+++
date = "2021-05-30"
title = "Udemy Downloader on Synology Disk Station"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.en.md"
+++
In this tutorial you will learn how to download "udemy" courses for offline use.
## Step 1: Prepare Udemy folder
I create a new directory called "udemy" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install Ubuntu image
I click on the "Registration" tab in the Synology Docker window and search for "ubunutu". I select the Docker image "ubunutu" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
I double click on my Ubuntu image. Then I click on "Advanced Settings" and activate the "Automatic Restart" here as well.
{{< gallery match="images/3/*.png" >}}
I select the tab "Volume" and click on "Add Folder". There I create a new folder with this mount path "/download".
{{< gallery match="images/4/*.png" >}}
Now the container can be started
{{< gallery match="images/5/*.png" >}}

## Step 4: Install Udemy Downloader
I click on "Container" in the Synology Docker window and double click on my "Udemy Container". Then I click on the "Terminal" tab and enter the following commands.
{{< gallery match="images/6/*.png" >}}

##  Orders:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Screenshots:
{{< gallery match="images/7/*.png" >}}

## Step 4: Get Udemy Downloader up and running
Now I still need an "access token". I visit Udemy with my Firefox browser and open Firebug. I click on the "Web Storage" tab and copy the "Access-Token".
{{< gallery match="images/8/*.png" >}}
I create a new file in my container:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
After that I can download the courses I have already purchased:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
See:
{{< gallery match="images/9/*.png" >}}
