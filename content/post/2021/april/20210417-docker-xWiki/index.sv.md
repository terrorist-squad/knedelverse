+++
date = "2021-04-17"
title = "Stora saker med behållare: Kör din egen xWiki på Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.sv.md"
+++
XWiki är en fri wiki-programvaruplattform skriven i Java och utformad med tanke på utbyggbarhet. Idag visar jag hur man installerar en xWiki-tjänst på Synology DiskStation.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered wikimappen
Jag skapar en ny katalog som heter "wiki" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera databasen
Därefter måste en databas skapas. Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "postgres". Jag väljer Docker-avbildningen "postgres" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image (fast tillstånd). Innan vi skapar en container från avbildningen måste vi göra några inställningar. Jag dubbelklickar på min postgres-avbildning.
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volym" och klickar på "Lägg till mapp". Där skapar jag en ny databasmapp med följande monteringssökväg "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Under "Portinställningar" raderas alla portar. Detta innebär att jag väljer port "5432" och tar bort den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszon|
|POSTGRES_DB	| xwiki |Detta är databasens namn.|
|POSTGRES_USER	| xwiki |Användarnamn för wikidatabasen.|
|POSTGRES_PASSWORD	| xwiki |Lösenord för wikidatabasanvändaren.|
{{</table>}}
Slutligen anger jag dessa fyra miljövariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mariadb-servern startas! Jag trycker på "Apply" överallt.
## Steg 3: Installera xWiki
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "xwiki". Jag väljer Docker-avbildningen "xwiki" och klickar sedan på taggen "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Jag dubbelklickar på min xwiki-bild. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/8/*.png" >}}
Jag tilldelar fasta portar för behållaren "xwiki". Utan fasta portar kan det vara så att "xwiki-servern" körs på en annan port efter en omstart.
{{< gallery match="images/9/*.png" >}}
Dessutom måste en "länk" till behållaren "postgres" skapas. Jag klickar på fliken "Länkar" och väljer databasbehållaren. Aliasnamnet ska komma ihåg för wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Tidszon|
|DB_HOST	| db |Aliasnamn / containerlänk|
|DB_DATABASE	| xwiki	|Uppgifter från steg 2|
|DB_USER	| xwiki	|Uppgifter från steg 2|
|DB_PASSWORD	| xwiki |Uppgifter från steg 2|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/11/*.png" >}}
Behållaren kan nu startas. Jag ringer xWiki-servern med Synologys IP-adress och min containerport.
{{< gallery match="images/12/*.png" >}}