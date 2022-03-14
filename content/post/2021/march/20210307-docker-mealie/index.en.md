+++
date = "2021-03-07"
title = "Great with Containers: Manage and Archive Recipes on Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-docker-mealie/index.en.md"
+++
Collect all your favorite recipes in the Docker container and organize them the way you want. Write your own recipes or import recipes from websites, for example "Chef", "Food
{{< gallery match="images/1/*.png" >}}

## Option for professionals
Of course, if you're an experienced Synology user, you can log in right away with SSH and install the whole setup via Docker Compose file.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Step 1: Find Docker image
I click on the "Registry" tab in the Synology Docker window and search for "mealie". I select the Docker image "hkotel/mealie:latest" and then click on the tag "latest".
{{< gallery match="images/2/*.png" >}}
After the image download, the image is available as an image. Docker distinguishes between 2 states, container "dynamic state" and image (fixed state). Before we now create a container from the image, a few settings must be made.
## Step 2: Put the image into operation:
I double click on my "mealie" image.
{{< gallery match="images/3/*.png" >}}
After that I click on "Advanced Settings" and activate the "Automatic Restart". I select the tab "Volume" and click on "Add Folder". There I create a new folder with this mount path "/app/data".
{{< gallery match="images/4/*.png" >}}
I assign fixed ports for the "Mealie" container. Without fixed ports it could be that the "Mealie-Server" runs on another port after a reboot.
{{< gallery match="images/5/*.png" >}}
Finally I enter two environment variables. The variable "db_type" is the database type and "TZ" the time zone "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
After these settings Mealie-Server can be started! After that you can call Mealie via the Ip address of the Synology disctation and the assigned port, for example http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## How does Mealie work?
If I move the mouse over the "Plus" button on the right/bottom and then click on the "Chain" symbol, I can enter a url. The Mealie -Application then searches itself for the required meta- and schema- information.
{{< gallery match="images/8/*.png" >}}
Importing works great (I've used these features with urls from chef, food
{{< gallery match="images/9/*.png" >}}
In edit mode I can also add a category. It is important that I press the "Enter" key once after each category. Otherwise this setting will not be applied.
{{< gallery match="images/10/*.png" >}}

## Special features
I noticed that the menu categories do not update automatically. Here you have to help with a browser reload.
{{< gallery match="images/11/*.png" >}}

## Other features
Of course, you can search recipes and also create menus. In addition, you can customize "Mealie" very extensively.
{{< gallery match="images/12/*.png" >}}
Mealie also looks great on mobile:
{{< gallery match="images/13/*.*" >}}

## Residual Api
At "http://gewaehlte-ip:und-port ... /docs" you can find the API documentation. Here you can find many methods that can be used for automation.
{{< gallery match="images/14/*.png" >}}

## Api example
Imagine the following fiction: "Gruner und Jahr launches the Internet portal Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Then clean up this list and fire it against the rest api, example:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Now you can reach the recipes offline:
{{< gallery match="images/15/*.png" >}}
