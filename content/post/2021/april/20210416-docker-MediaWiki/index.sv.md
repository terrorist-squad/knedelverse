+++
date = "2021-04-16"
title = "Stora saker med behållare: Installera din egen MediaWiki på Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.sv.md"
+++
MediaWiki är ett PHP-baserat wikisystem som finns tillgängligt gratis som en öppen källkodsprodukt. Idag visar jag hur man installerar en MediaWiki-tjänst på en Synology diskstation.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered MediaWiki-mappen
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
|TZ	| Europe/Berlin	|Tidszon|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Huvudlösenord för databasen.|
|MYSQL_DATABASE |	my_wiki	|Detta är databasens namn.|
|MYSQL_USER	| wikiuser |Användarnamn för wikidatabasen.|
|MYSQL_PASSWORD	| my_wiki_pass |Lösenord för wikidatabasanvändaren.|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mariadb-servern startas! Jag trycker på "Apply" överallt.
## Steg 3: Installera MediaWiki
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "mediawiki". Jag väljer Docker-avbildningen "mediawiki" och klickar sedan på taggen "latest".
{{< gallery match="images/7/*.png" >}}
Jag dubbelklickar på min Mediawiki-bild.
{{< gallery match="images/8/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här. Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med denna monteringssökväg "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Jag tilldelar fasta portar för behållaren "MediaWiki". Utan fasta portar kan det hända att "MediaWiki-servern" körs på en annan port efter en omstart.
{{< gallery match="images/10/*.png" >}}
Dessutom måste en "länk" till behållaren "mariadb" fortfarande skapas. Jag klickar på fliken "Länkar" och väljer databasbehållaren. Aliasnamnet ska komma ihåg för wiki-installationen.
{{< gallery match="images/11/*.png" >}}
Slutligen anger jag en miljövariabel "TZ" med värdet "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Behållaren kan nu startas. Jag ringer Mediawiki-servern med Synologys IP-adress och min containerport. Under Databasserver anger jag aliasnamnet för databasbehållaren. Jag anger också databasnamnet, användarnamnet och lösenordet från "Steg 2".
{{< gallery match="images/13/*.png" >}}
