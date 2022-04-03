+++
date = "2021-04-16"
title = "Stora saker med behållare: Installera Wiki.js på Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.sv.md"
+++
Wiki.js är en kraftfull wiki-programvara med öppen källkod som gör dokumentation till ett nöje med sitt enkla gränssnitt. Idag visar jag hur man installerar en Wiki.js-tjänst på Synology DiskStation.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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
Du kan hitta fler användbara Docker-avbildningar för hemmabruk i Dockerverse.
## Steg 1: Förbered wikimappen
Jag skapar en ny katalog som heter "wiki" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera databasen
Därefter måste en databas skapas. Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "mysql". Jag väljer Docker-avbildningen "mysql" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image (fast tillstånd). Innan vi skapar en behållare från avbildningen måste vi göra några inställningar. Jag dubbelklickar på min mysql-avbildning.
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny databasmapp med följande monteringssökväg "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Portinställningar" raderas alla portar. Det innebär att jag väljer port "3306" och tar bort den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tidszon|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Huvudlösenord för databasen.|
|MYSQL_DATABASE |	my_wiki |Detta är databasens namn.|
|MYSQL_USER	| wikiuser |Användarnamn för wikidatabasen.|
|MYSQL_PASSWORD |	my_wiki_pass	|Lösenord för wikidatabasanvändaren.|
{{</table>}}
Slutligen anger jag dessa fyra miljövariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mariadb-servern startas! Jag trycker på "Apply" överallt.
## Steg 3: Installera Wiki.js
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "wiki". Jag väljer Docker-avbildningen "requarks/wiki" och klickar sedan på taggen "latest".
{{< gallery match="images/7/*.png" >}}
Jag dubbelklickar på min WikiJS-bild. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/8/*.png" >}}
Jag tilldelar fasta portar för WikiJS-behållaren. Utan fasta portar kan det vara så att "bookstack-servern" körs på en annan port efter en omstart.
{{< gallery match="images/9/*.png" >}}
Dessutom måste en "länk" till behållaren "mysql" skapas. Jag klickar på fliken "Länkar" och väljer databasbehållaren. Aliasnamnet ska komma ihåg för wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszon|
|DB_HOST	| wiki-db	|Aliasnamn / containerlänk|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Uppgifter från steg 2|
|DB_USER	| wikiuser |Uppgifter från steg 2|
|DB_PASS	| my_wiki_pass	|Uppgifter från steg 2|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/11/*.png" >}}
Behållaren kan nu startas. Jag kallar Wiki.js-servern med Synologys IP-adress och min containerport/3000.
{{< gallery match="images/12/*.png" >}}
