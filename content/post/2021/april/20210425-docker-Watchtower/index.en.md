+++
date = "2021-04-25T09:28:11+01:00"
title = "Short story: Automatically update containers with Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.en.md"
+++
If you run Docker containers on your disk station, you naturally want them to always be up to date. Watchtower updates images and containers automatically. This way you can enjoy the latest features and the most up-to-date data security. Today I will show you how to install Watchtower on your Synology DiskStation.
## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Install Watchtower
I use the console for this:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
After that, Watchtower always runs in the background.
{{< gallery match="images/3/*.png" >}}

