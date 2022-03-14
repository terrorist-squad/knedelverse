+++
date = "2020-02-28"
title = "Stora saker med behållare: Kör Papermerge DMS på en Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.sv.md"
+++
Papermerge är ett nytt dokumenthanteringssystem (DMS) som automatiskt kan tilldela och bearbeta dokument. I den här handledningen visar jag hur jag installerade Papermerge på min Synology diskstation och hur DMS fungerar.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Steg 1: Skapa en mapp
Först skapar jag en mapp för papperssammanläggningen. Jag går till "System Control" -> "Shared Folder" och skapar en ny mapp som heter "Document Archive".
{{< gallery match="images/1/*.png" >}}
Steg 2: Sök efter Docker-avbildningenJag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "Papermerge". Jag väljer Docker-avbildningen "linuxserver/papermerge" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Steg 3: Använd bilden:
Jag dubbelklickar på min bild för papperssammanfogning.
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volym" och klickar på "Lägg till mapp". Där skapar jag en ny databasmapp med denna monteringssökväg "/data".
{{< gallery match="images/4/*.png" >}}
Jag lagrar också en andra mapp här som jag inkluderar i monteringssökvägen "/config". Det spelar ingen roll var mappen finns. Det är dock viktigt att den tillhör användaren Synology admin.
{{< gallery match="images/5/*.png" >}}
Jag tilldelar containern "Papermerge" fasta portar. Utan fasta portar kan det vara så att "Papermerge-servern" körs på en annan port efter en omstart.
{{< gallery match="images/6/*.png" >}}
Slutligen anger jag tre miljövariabler. Variabeln "PUID" är användar-ID och "PGID" är grupp-ID för min administratörsanvändare. Du kan ta reda på PGID/PUID via SSH med kommandot "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Efter dessa inställningar kan Papermerge-servern startas! Därefter kan Papermerge anropas via Ip-adressen till Synology-disctationen och den tilldelade porten, t.ex. http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Standardinloggningen är admin med lösenordet admin.
## Hur fungerar Papermerge?
Papermerge analyserar texten i dokument och bilder. Papermerge använder ett OCR-bibliotek (optisk teckenigenkänning) som heter tesseract och som publiceras av Goolge.
{{< gallery match="images/9/*.png" >}}
Jag skapade en mapp som heter "Allt med Lorem" för att testa den automatiska dokumenttilldelningen. Sedan klickade jag ihop ett nytt igenkänningsmönster i menyalternativet "Automates".
{{< gallery match="images/10/*.png" >}}
Alla nya dokument som innehåller ordet "Lorem" placeras i mappen "Allt med Lorem" och märks med "has-lorem". Det är viktigt att använda ett kommatecken i taggarna, annars kommer taggen inte att anges. Om du laddar upp ett motsvarande dokument kommer det att märkas och sorteras.
{{< gallery match="images/11/*.png" >}}