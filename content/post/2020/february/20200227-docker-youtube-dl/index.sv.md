+++
date = "2020-02-27"
title = "Stora saker med behållare: Kör Youtube-downloader på Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.sv.md"
+++
Många av mina vänner vet att jag driver en privat videoportal för inlärning på mitt Homelab-nätverk. Jag har sparat videokurser från tidigare medlemskap i lärportalerna och bra Youtube-handledningar för att kunna använda dem offline på min NAS.
{{< gallery match="images/1/*.png" >}}
Med tiden har jag samlat 8845 videokurser med 282616 enskilda videor. Den totala drifttiden är ungefär 2 år. I den här handledningen visar jag hur du kan säkerhetskopiera bra Youtube-handledningar med en Docker-downloadtjänst för offlinebruk.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Steg 1
Först skapar jag en mapp för nedladdningarna. Jag går till "System Control" -> "Shared Folder" och skapar en ny mapp som heter "Downloads".
{{< gallery match="images/2/*.png" >}}

## Steg 2: Sök efter Docker-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "youtube-dl-nas". Jag väljer Docker-avbildningen "modenaf360/youtube-dl-nas" och klickar sedan på taggen "latest".
{{< gallery match="images/3/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Steg 3: Använd bilden:
Jag dubbelklickar på min youtube-dl-nas-bild.
{{< gallery match="images/4/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volym" och klickar på "Lägg till mapp". Där skapar jag en ny databasmapp med denna monteringssökväg "/downfolder".
{{< gallery match="images/5/*.png" >}}
Jag tilldelar fasta portar för behållaren "Youtube Downloader". Utan fasta portar kan det vara så att "Youtube Downloader" körs på en annan port efter en omstart.
{{< gallery match="images/6/*.png" >}}
Slutligen anger jag två miljövariabler. Variabeln "MY_ID" är mitt användarnamn och "MY_PW" är mitt lösenord.
{{< gallery match="images/7/*.png" >}}
Efter dessa inställningar kan Downloader startas! Därefter kan du ringa upp nedladdaren via Ip-adressen till Synology-disctationen och den tilldelade porten, till exempel http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
För autentisering tar du användarnamnet och lösenordet från MY_ID och MY_PW.
## Steg 4: Nu kör vi
Nu kan du ange webbadresser för Youtube-videor och spellistor i fältet "URL" och alla videor hamnar automatiskt i nedladdningsmappen på Synology Disk Station.
{{< gallery match="images/9/*.png" >}}
Ladda ner mappen:
{{< gallery match="images/10/*.png" >}}