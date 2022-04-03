+++
date = "2021-04-16"
title = "Great things with containers: Installing your own MediaWiki on Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.en.md"
+++
MediaWiki is a PHP-based wiki system that is available for free as an open source product. Today I show how to install a MediaWiki service on the Synology disk station.
## Option for professionals
Of course, as an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: Prepare MediaWiki folder
I create a new directory named "wiki" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install database
After that, a database needs to be created. I click on the "Registration" tab in the Synology Docker window and search for "mariadb". I select the Docker image "mariadb" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.I double-click on my mariadb image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the "Volume" tab and click on "Add Folder". There I create a new database folder with this mount path "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Port Settings" all ports are deleted. This means that I select the "3306" port and delete it with the "-" button.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What is it?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Time zone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Master password of the database.|
|MYSQL_DATABASE |	my_wiki	|This is the database name.|
|MYSQL_USER	| wikiuser |User name of the wiki database.|
|MYSQL_PASSWORD	| my_wiki_pass |Password of the wiki database user.|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/6/*.png" >}}
After these settings Mariadb server can be started! I press "Apply" everywhere.
## Step 3: Install MediaWiki
I click on the "Registration" tab in the Synology Docker window and search for "mediawiki". I select the Docker image "mediawiki" and then click on the tag "latest".
{{< gallery match="images/7/*.png" >}}
I double-click on my Mediawiki image.
{{< gallery match="images/8/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart" here as well. I select the "Volume" tab and click on "Add Folder". There I create a new folder with this mount path "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
I assign fixed ports for the "MediaWiki" container. Without fixed ports it could be that the "MediaWiki server" runs on another port after a restart.
{{< gallery match="images/10/*.png" >}}
Also, a "link" to the "mariadb" container still needs to be created. I click on the "Links" tab and select the database container. The alias name should be remembered well for the wiki installation.
{{< gallery match="images/11/*.png" >}}
Finally, I enter an environment variable "TZ" with value "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
The container can now be started. I call the Mediawiki server with the Synology IP address and my container port. At Database server I enter the alias name of the database container. I also enter the database name, user name and the password from "Step 2".
{{< gallery match="images/13/*.png" >}}
