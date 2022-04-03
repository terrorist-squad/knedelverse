+++
date = "2022-04-02"
title = "Great things with containers: Install Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.en.md"
+++
With Jitsi you can create and deploy a secure video conferencing solution. Today I show how to install a Jitsi service on a server, reference: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Step 1: Create "jitsi" folder
I create a new directory called "jitsi" for the installation.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Step 2: Configuration
Now I copy the default configuration and adjust it.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
See:
{{< gallery match="images/1/*.png" >}}
To use strong passwords in the .env file security options, the following bash script should be run once.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Now I create some more folders for Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
After that, the Jitsi server can be started.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
After that you can use the Jitsi server!
{{< gallery match="images/2/*.png" >}}

