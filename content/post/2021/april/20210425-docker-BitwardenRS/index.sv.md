+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS på Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.sv.md"
+++
Bitwarden är en gratis lösenordshanteringstjänst med öppen källkod som lagrar konfidentiell information, t.ex. inloggningsuppgifter till webbplatser, i ett krypterat valv. Idag visar jag hur man installerar en BitwardenRS på Synology DiskStation.
## Steg 1: Förbered BitwardenRS-mappen
Jag skapar en ny katalog som heter "bitwarden" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera BitwardenRS
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "bitwarden". Jag väljer Docker-avbildningen "bitwardenrs/server" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
Jag dubbelklickar på min bitwardenrs bild. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/3/*.png" >}}
Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med denna monteringssökväg "/data".
{{< gallery match="images/4/*.png" >}}
Jag tilldelar containern "bitwardenrs" fasta portar. Utan fasta portar kan det vara så att "bitwardenrs-servern" körs på en annan port efter en omstart. Den första containerporten kan tas bort. Den andra hamnen bör man komma ihåg.
{{< gallery match="images/5/*.png" >}}
Behållaren kan nu startas. Jag ringer bitwardenrs-servern med Synologys IP-adress och min containerport 8084.
{{< gallery match="images/6/*.png" >}}

## Steg 3: Ställ in HTTPS
Jag klickar på "Control Panel" > "Reverse Proxy" och "Create".
{{< gallery match="images/7/*.png" >}}
Därefter kan jag ringa bitwardenrs-servern med Synologys IP-adress och min proxyport 8085, krypterad.
{{< gallery match="images/8/*.png" >}}