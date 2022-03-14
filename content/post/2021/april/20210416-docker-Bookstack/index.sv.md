+++
date = "2021-04-16"
title = "Stora saker med behållare: Din egen Bookstack Wiki på Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.sv.md"
+++
Bookstack är ett alternativ med öppen källkod till MediaWiki eller Confluence. Idag visar jag hur man installerar en Bookstack-tjänst på Synologys diskstation.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered mappen Bookstack
Jag skapar en ny katalog som heter "wiki" i Dockerkatalogen.
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
|TZ	| Europe/Berlin |Tidszon|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Huvudlösenord för databasen.|
|MYSQL_DATABASE | 	my_wiki	|Detta är databasens namn.|
|MYSQL_USER	|  wikiuser	|Användarnamn för wikidatabasen.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Lösenord för wikidatabasanvändaren.|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mariadb-servern startas! Jag trycker på "Apply" överallt.
## Steg 3: Installera Bookstack
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "bookstack". Jag väljer Docker-avbildningen "solidnerd/bookstack" och klickar sedan på taggen "latest".
{{< gallery match="images/7/*.png" >}}
Jag dubbelklickar på min Bookstack-bild. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/8/*.png" >}}
Jag tilldelar containern "bookstack" fasta portar. Utan fasta portar kan det vara så att "bookstack-servern" körs på en annan port efter en omstart. Den första containerporten kan tas bort. Den andra hamnen bör man komma ihåg.
{{< gallery match="images/9/*.png" >}}
Dessutom måste en "länk" till behållaren "mariadb" fortfarande skapas. Jag klickar på fliken "Länkar" och väljer databasbehållaren. Aliasnamnet ska komma ihåg för wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tidszon|
|DB_HOST	| wiki-db:3306	|Aliasnamn / containerlänk|
|DB_DATABASE	| my_wiki |Uppgifter från steg 2|
|DB_USERNAME	| wikiuser |Uppgifter från steg 2|
|DB_PASSWORD	| my_wiki_pass	|Uppgifter från steg 2|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/11/*.png" >}}
Behållaren kan nu startas. Det kan ta lite tid att skapa databasen. Beteendet kan observeras via behållardetaljerna.
{{< gallery match="images/12/*.png" >}}
Jag ringer Bookstack-servern med Synologys IP-adress och min containerport. Inloggningsnamnet är "admin@admin.com" och lösenordet är "password".
{{< gallery match="images/13/*.png" >}}
