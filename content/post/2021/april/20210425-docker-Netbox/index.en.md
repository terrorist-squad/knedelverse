+++
date = "2021-04-25T09:28:11+01:00"
title = "Great things with containers: Netbox on Synology - Diskstation"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.en.md"
+++
NetBox is a free software used for computer network management. Today I will show how to install a Netbox service on Synology DiskStation.
## Step 1: Prepare Synology
The first thing to do is to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password (Windows users take Putty or WinSCP).
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Create NETBOX folder
I create a new directory called "netbox" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
Now the following file must be downloaded and unpacked in the directory: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. I use the console for this:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Then I edit the "docker/docker-compose.yml" file and enter my Synology addresses there at "netbox-media-files", "netbox-postgres-data" and "netbox-redis-data":
```
version: '3.4'
services:
  netbox: 
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: 'unit:root'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
    
  netbox-worker:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    - rqworker

  netbox-housekeeping:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/housekeeping.sh

  # postgres
  postgres:
    image: postgres:14-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data

  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env


```
Very important is that the inheritance "<<: *netbox" is replaced and a port for "netbox" is entered.After that I can start the compose file:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
It may take some time to create the database. The behavior can be observed via the container details.
{{< gallery match="images/4/*.png" >}}
I call the netbox server with the Synology IP address and my container port.
{{< gallery match="images/5/*.png" >}}
