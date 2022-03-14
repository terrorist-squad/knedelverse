+++
date = "2021-04-16"
title = "Great things with containers: Installing Wiki.js on the Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.en.md"
+++
Wiki.js is a powerful open source wiki software that makes documentation a pleasure with its simple interface. Today I show how to install a Wiki.js service on the Synology DiskStation.
## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
You can find more useful Docker images for home use in the Dockerverse.
## Step 1: Prepare wiki folder
I create a new directory called "wiki" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install database
After that, a database needs to be created. I click on the "Registration" tab in the Synology Docker window and search for "mysql". I select the Docker image "mysql" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.I double-click on my mysql image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the tab "Volume" and click on "Add Folder". There I create a new database folder with this mount path "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Port Settings" all ports are deleted. This means that I select the "3306" port and delete it with the "-" button.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What's that?|
|--- | --- |---|
|TZ	| Europe/Berlin |Time zone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Master password of the database.|
|MYSQL_DATABASE |	my_wiki |This is the database name.|
|MYSQL_USER	| wikiuser |User name of the wiki database.|
|MYSQL_PASSWORD |	my_wiki_pass	|Password of the wiki database user.|
{{</table>}}
Finally, I enter these four environment variables:See:
{{< gallery match="images/6/*.png" >}}
After these settings Mariadb server can be started! I press "Apply" everywhere.
## Step 3: Install Wiki.js
I click on the "Registry" tab in the Synology Docker window and search for "wiki". I select the Docker image "requarks/wiki" and then click on the tag "latest".
{{< gallery match="images/7/*.png" >}}
I double-click on my WikiJS image. After that I click on "Advanced Settings" and activate the "Automatic Restart" here as well.
{{< gallery match="images/8/*.png" >}}
I assign fixed ports for the "WikiJS" container. Without fixed ports it could be that the "bookstack server" runs on a different port after a restart.
{{< gallery match="images/9/*.png" >}}
Also, a "link" to the "mysql" container still needs to be created. I click on the "Links" tab and select the database container. The alias name should be well remembered for the wiki installation.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What's that?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Time zone|
|DB_HOST	| wiki-db	|Alias names / container link|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Data from step 2|
|DB_USER	| wikiuser |Data from step 2|
|DB_PASS	| my_wiki_pass	|Data from step 2|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/11/*.png" >}}
The container can now be started. I call the Wiki.js server with the Synology IP address and my container port/3000.
{{< gallery match="images/12/*.png" >}}