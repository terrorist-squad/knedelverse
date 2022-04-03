+++
date = "2021-04-18"
title = "Store ting med containere: Installation af din egen dokuWiki på Synology diskstation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.da.md"
+++
DokuWiki er et standardkonformt, brugervenligt og samtidig ekstremt alsidigt open source-wikisoftware. I dag viser jeg, hvordan man installerer en DokuWiki-tjeneste på Synology diskstationen.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
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
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered wikimappe
Jeg opretter en ny mappe med navnet "wiki" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer DokuWiki
Herefter skal der oprettes en database. Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "dokuwiki". Jeg vælger Docker-image "bitnami/dokuwiki" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image (fast tilstand). Før vi opretter en container fra billedet, skal der foretages et par indstillinger. Jeg dobbeltklikker på mit dokuwiki-billede.
{{< gallery match="images/3/*.png" >}}
Jeg tildeler faste porte til "dokuwiki"-containeren. Uden faste porte kan det være, at "dokuwiki-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszone|
|DOKUWIKI_USERNAME	| admin|Brugernavn til administrator|
|DOKUWIKI_FULL_NAME |	wiki	|WIki-navn|
|DOKUWIKI_PASSWORD	| password	|Admins adgangskode|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/5/*.png" >}}
Beholderen kan nu startes. Jeg kalder dokuWIki-serveren med Synologys IP-adresse og min containerport.
{{< gallery match="images/6/*.png" >}}

