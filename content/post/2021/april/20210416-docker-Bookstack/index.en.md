+++
date = "2021-04-16"
title = "Great things with containers: Own Bookstack Wiki on Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.en.md"
+++
Bookstack is an "open source" alternative to MediaWiki or Confluence. Today I show how to install a Bookstack service on the Synology Diskstation.
## Option for professionals
Of course, as an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: Prepare bookstack folder
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
|TZ	| Europe/Berlin |Time zone|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Master password of the database.|
|MYSQL_DATABASE | 	my_wiki	|This is the database name.|
|MYSQL_USER	|  wikiuser	|User name of the wiki database.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Password of the wiki database user.|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/6/*.png" >}}
After these settings Mariadb server can be started! I press "Apply" everywhere.
## Step 3: Install Bookstack
I click on the "Registration" tab in the Synology Docker window and search for "bookstack". I select the Docker image "solidnerd/bookstack" and then click on the tag "latest".
{{< gallery match="images/7/*.png" >}}
I double-click on my Bookstack image. Then I click on "Advanced Settings" and activate the "Automatic Restart" here as well.
{{< gallery match="images/8/*.png" >}}
I assign fixed ports for the "bookstack" container. Without fixed ports it could be that the "bookstack server" runs on another port after a restart. The first container port can be deleted. The other port should be remembered.
{{< gallery match="images/9/*.png" >}}
Also, a "link" to the "mariadb" container still needs to be created. I click on the "Links" tab and select the database container. The alias name should be remembered well for the wiki installation.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What is it?|
|--- | --- |---|
|TZ	| Europe/Berlin |Time zone|
|DB_HOST	| wiki-db:3306	|Alias / Container link|
|DB_DATABASE	| my_wiki |Data from step 2|
|DB_USERNAME	| wikiuser |Data from step 2|
|DB_PASSWORD	| my_wiki_pass	|Data from step 2|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/11/*.png" >}}
The container can now be started. It may take some time to create the database. The behavior can be observed via the container details.
{{< gallery match="images/12/*.png" >}}
I call the Bookstack server with the Synology IP address and my container port. The login name is "admin@admin.com" and the password is "password".
{{< gallery match="images/13/*.png" >}}

