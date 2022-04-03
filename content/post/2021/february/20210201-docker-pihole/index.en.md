+++
date = "2021-02-01"
title = "Great things with containers: Pihole on Synology Diskstation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.en.md"
+++
Today I show how to install a Pihole service on the Synology disk station and connect it to the Fritzbox.
## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Create Pihole folder
I create a new directory called "pihole" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Then I change to the new directory and create two folders "etc-pihole" and "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Now the following Docker Compose file named "pihole.yml" must be placed in the Pihole directory:
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
The container can now be started:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
I call the Pihole server with the Synology IP address and my container port and log in with the WEBPASSWORD password.
{{< gallery match="images/4/*.png" >}}
Now the DNS address can be changed in the Fritzbox under "Home Network" > "Network" > "Network Settings".
{{< gallery match="images/5/*.png" >}}
