+++
date = "2021-09-05"
title = "Great things with containers: Logitech media server on Synology disk station"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.en.md"
+++
In this tutorial, you will learn how to install a Logitech media server on Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Step 1: Prepare Logitech Media Server folder
I create a new directory named "logitechmediaserver" in the Docker directory.
{{< gallery match="images/2/*.png" >}}

## Step 2: Install Logitechmediaserver image
I click on the "Registration" tab in the Synology Docker window and search for "logitechmediaserver". I select the Docker image "lmscommunity/logitechmediaserver" and then click on the tag "latest".
{{< gallery match="images/3/*.png" >}}
I double-click on my Logitech Mediaserver image. Then I click on "Advanced Settings" and activate the "Automatic Restart" here as well.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/music|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
I select the "Volume" tab and click on "Add Folder". There I create three folders:See:
{{< gallery match="images/5/*.png" >}}
I assign fixed ports for the "Logitechmediaserver" container. Without fixed ports it could be that the "Logitechmediaserver-Server" runs on another port after a reboot.
{{< gallery match="images/6/*.png" >}}
Finally, I enter an environment variable. The variable "TZ" the time zone "Europe/Berlin".
{{< gallery match="images/7/*.png" >}}
After these settings Logitechmediaserver server can be started! After that you can call Logitechmediaserver via the Ip address of the Synology disctation and the assigned port, for example http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

