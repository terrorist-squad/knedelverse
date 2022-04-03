+++
date = "2021-04-17"
title = "Great things with containers: Running your own xWiki on Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.en.md"
+++
XWiki is a free wiki software platform written in Java and designed with extensibility in mind. Today I'll show how to install an xWiki service on the Synology DiskStation.
## Option for professionals
Of course, as an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Step 1: Prepare wiki folder
I create a new directory named "wiki" in the Docker directory.
{{< gallery match="images/1/*.png" >}}

## Step 2: Install database
After that, a database needs to be created. I click on the "Registry" tab in the Synology Docker window and search for "postgres". I select the Docker image "postgres" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.I double-click on my postgres image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced settings" and activate the "Automatic restart". I select the "Volume" tab and click on "Add Folder". There I create a new database folder with this mount path "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Under "Port Settings" all ports are deleted. This means that I select the "5432" port and delete it with the "-" button.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What is it?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Time zone|
|POSTGRES_DB	| xwiki |This is the database name.|
|POSTGRES_USER	| xwiki |User name of the wiki database.|
|POSTGRES_PASSWORD	| xwiki |Password of the wiki database user.|
{{</table>}}
Finally, I enter these four environment variables:See:
{{< gallery match="images/6/*.png" >}}
After these settings Mariadb server can be started! I press "Apply" everywhere.
## Step 3: Install xWiki
I click on the "Registration" tab in the Synology Docker window and search for "xwiki". I select the Docker image "xwiki" and then click on the tag "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
I double click on my xwiki image. After that I click on "Advanced settings" and activate the "Automatic restart" here as well.
{{< gallery match="images/8/*.png" >}}
I assign fixed ports for the "xwiki" container. Without fixed ports it could be that the "xwiki server" runs on another port after a restart.
{{< gallery match="images/9/*.png" >}}
Also, a "link" to the "postgres" container still needs to be created. I click on the "Links" tab and select the database container. The alias name should be well remembered for the wiki installation.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variable name|Value|What is it?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Time zone|
|DB_HOST	| db |Alias / Container link|
|DB_DATABASE	| xwiki	|Data from step 2|
|DB_USER	| xwiki	|Data from step 2|
|DB_PASSWORD	| xwiki |Data from step 2|
{{</table>}}
Finally, I enter these environment variables:See:
{{< gallery match="images/11/*.png" >}}
The container can now be started. I call the xWiki server with the Synology IP address and my container port.
{{< gallery match="images/12/*.png" >}}
