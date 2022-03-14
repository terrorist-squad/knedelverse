+++
date = "2021-04-16"
title = "Great things with containers: Own bookstack wiki on Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.en.md"
+++
Bookstack is an "open source" alternative to MediaWiki or Confluence. Today I show how to install a Bookstack service on the Synology Diskstation.
## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
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
## Step 1: Prepare Bookstack folder
I create a new directory called "wiki" in the Docker directory.
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
Error:LibreSSL SSL_read: SSL_ERROR_SYSCALL, errno 50|--- | --- ||
Error:Could not resolve host: api.deepl.com|TZ	| Europe/Berlin ||
Error:Could not resolve host: api.deepl.com|MYSQL_ROOT_PASSWORD	|  my_wiki_pass ||
Error:Could not resolve host: api.deepl.com|MYSQL_DATABASE | 	my_wiki	||
Error:Could not resolve host: api.deepl.com|MYSQL_USER	|  wikiuser	||
Error:Could not resolve host: api.deepl.com|MYSQL_PASSWORD	|  my_wiki_pass	||
{{</table>}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/6/*.png" >}}
Error:Could not resolve host: api.deepl.com
Error:Could not resolve host: api.deepl.com## 
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/7/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/8/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/9/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
Error:Could not resolve host: api.deepl.comError:Could not resolve host: api.deepl.comError:Could not resolve host: api.deepl.com||||
Error:Could not resolve host: api.deepl.com|--- | --- ||
Error:Could not resolve host: api.deepl.com|TZ	| Europe/Berlin ||
Error:Could not resolve host: api.deepl.com|DB_HOST	| wiki-db:3306	||
Error:Could not resolve host: api.deepl.com|DB_DATABASE	| my_wiki ||
Error:Could not resolve host: api.deepl.com|DB_USERNAME	| wikiuser ||
Error:Could not resolve host: api.deepl.com|DB_PASSWORD	| my_wiki_pass	||
{{</table>}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/11/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/12/*.png" >}}
Error:Could not resolve host: api.deepl.com
{{< gallery match="images/13/*.png" >}}
