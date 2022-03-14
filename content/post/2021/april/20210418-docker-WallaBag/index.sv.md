+++
date = "2021-04-18"
title = "Stora saker med behållare: Egen WallaBag på Synologys diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.sv.md"
+++
Wallabag är ett program för att arkivera intressanta webbplatser eller artiklar. Idag visar jag hur man installerar en Wallabag-tjänst på Synologys diskstation.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered wallabag-mappen
Jag skapar en ny katalog som heter "wallabag" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera databasen
Därefter måste en databas skapas. Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "mariadb". Jag väljer Docker-avbildningen "mariadb" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image (fast tillstånd). Innan vi skapar en container från avbildningen måste vi göra några inställningar. Jag dubbelklickar på min mariadb-avbildning.
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny databasmapp med följande monteringssökväg "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Portinställningar" raderas alla portar. Det innebär att jag väljer port "3306" och tar bort den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ| Europe/Berlin	|Tidszon|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Huvudlösenord för databasen.|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mariadb-servern startas! Jag trycker på "Apply" överallt.
{{< gallery match="images/7/*.png" >}}

## Steg 3: Installera Wallabag
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "wallabag". Jag väljer Docker-avbildningen "wallabag/wallabag" och klickar sedan på taggen "latest".
{{< gallery match="images/8/*.png" >}}
Jag dubbelklickar på min wallabag-bild. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/9/*.png" >}}
Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med följande monteringssökväg "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Jag tilldelar containern "wallabag" fasta portar. Utan fasta portar kan det vara så att "wallabag-servern" körs på en annan port efter en omstart. Den första containerporten kan tas bort. Den andra hamnen bör man komma ihåg.
{{< gallery match="images/11/*.png" >}}
Dessutom måste en "länk" till behållaren "mariadb" fortfarande skapas. Jag klickar på fliken "Länkar" och väljer databasbehållaren. Aliasnamnet ska komma ihåg för wallabag-installationen.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Värde|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Vänligen ändra|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|falskt|
|SYMFONY__ENV__TWOFACTOR_AUTH	|falskt|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/13/*.png" >}}
Behållaren kan nu startas. Det kan ta lite tid att skapa databasen. Beteendet kan observeras via behållardetaljerna.
{{< gallery match="images/14/*.png" >}}
Jag ringer till wallabag-servern med Synologys IP-adress och min containerport.
{{< gallery match="images/15/*.png" >}}
