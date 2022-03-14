+++
date = "2021-04-18"
title = "Stora saker med behållare: Installera din egen dokuWiki på Synology diskstation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.sv.md"
+++
DokuWiki är en standardkompatibel, lättanvänd och samtidigt extremt mångsidig wiki-programvara med öppen källkod. Idag visar jag hur man installerar en DokuWiki-tjänst på Synology diskstationen.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered wikimappen
Jag skapar en ny katalog som heter "wiki" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera DokuWiki
Därefter måste en databas skapas. Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "dokuwiki". Jag väljer Docker-avbildningen "bitnami/dokuwiki" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image (fast tillstånd). Innan vi skapar en behållare från avbildningen måste vi göra några inställningar. Jag dubbelklickar på min dokuwiki-avbildning.
{{< gallery match="images/3/*.png" >}}
Jag tilldelar fasta portar för behållaren "dokuwiki". Utan fasta portar kan det vara så att "dokuwiki-servern" körs på en annan port efter en omstart.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszon|
|DOKUWIKI_USERNAME	| admin|Användarnamn för administratör|
|DOKUWIKI_FULL_NAME |	wiki	|WIki-namn|
|DOKUWIKI_PASSWORD	| password	|Admin-lösenord|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/5/*.png" >}}
Behållaren kan nu startas. Jag ringer dokuWIki-servern med Synologys IP-adress och min containerport.
{{< gallery match="images/6/*.png" >}}
