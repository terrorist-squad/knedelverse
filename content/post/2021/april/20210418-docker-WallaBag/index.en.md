+++
date = "2021-04-18"
title = "Great things with containers: Own WallaBag on the Synology disk station"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.en.md"
+++
Wallabag is a program for archiving interesting web pages or articles. Today I'll show you how to install a Wallabag service on your Synology DiskStation.
## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: prepare wallabag folder
I create a new directory called "wallabag" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install database
After that, a database needs to be created. I click on the "Registration" tab in the Synology Docker window and search for "mariadb". I select the Docker image "mariadb" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.I double-click on my mariadb image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the tab "Volume" and click on "Add Folder". There I create a new database folder with this mount path "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Port Settings" all ports are deleted. This means that I select the "3306" port and delete it with the "-" button.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What's that?|
|--- | --- |---|
|TZ| Europe/Berlin	|Time zone|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Master password of the database.|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/6/*.png" >}}
After these settings Mariadb server can be started! I press "Apply" everywhere.
{{< gallery match="images/7/*.png" >}}

## Step 3: Install Wallabag
I click on the "Registration" tab in the Synology Docker window and search for "wallabag". I select the Docker image "wallabag/wallabag" and then click on the tag "latest".
{{< gallery match="images/8/*.png" >}}
I double click on my wallabag image. Then I click on "Advanced settings" and activate the "Automatic restart" here as well.
{{< gallery match="images/9/*.png" >}}
I select the "Volume" tab and click on "Add Folder". There I create a new folder with this mount path "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
I assign fixed ports for the "wallabag" container. Without fixed ports it could happen that the "wallabag-server" runs on another port after a reboot. The first container port can be deleted. The other port should be remembered.
{{< gallery match="images/11/*.png" >}}
Also, a "link" to the "mariadb" container still needs to be created. I click on the "Links" tab and select the database container. The alias name should be well remembered for the wallabag installation.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Value|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Please modify|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|false|
|SYMFONY__ENV__TWOFACTOR_AUTH	|false|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/13/*.png" >}}
The container can now be started. It may take some time to create the database. The behavior can be observed via the container details.
{{< gallery match="images/14/*.png" >}}
I call the wallabag server with the Synology IP address and my container port.
{{< gallery match="images/15/*.png" >}}
