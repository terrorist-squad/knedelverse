+++
date = "2020-02-13"
title = "Synology-Nas: Installera Calibre Web som ett e-boksbibliotek"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.sv.md"
+++
Hur installerar jag Calibre-Web som en Docker-behållare på min Synology NAS? Uppmärksamhet: Denna installationsmetod är föråldrad och är inte kompatibel med den aktuella Calibre-programvaran. Ta en titt på denna nya handledning:[Stora saker med containrar: Kör Calibre med Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Stora saker med containrar: Kör Calibre med Docker Compose"). Den här handledningen är avsedd för alla som arbetar med Synology DS.
## Steg 1: Skapa en mapp
Först skapar jag en mapp för Calibre-biblioteket.  Jag öppnar "Systemkontroll" -> "Delad mapp" och skapar en ny mapp "Böcker".
{{< gallery match="images/1/*.png" >}}

##  Steg 2: Skapa ett Calibre-bibliotek
Nu kopierar jag ett befintligt bibliotek eller "[detta tomma exempelbibliotek](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" till den nya katalogen. Jag har själv kopierat det befintliga biblioteket i skrivbordsprogrammet.
{{< gallery match="images/2/*.png" >}}

## Steg 3: Sök efter Docker-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "Calibre". Jag väljer Docker-avbildningen "janeczku/calibre-web" och klickar sedan på taggen "latest".
{{< gallery match="images/3/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Steg 4: Använd bilden:
Jag dubbelklickar på min Calibre-bild.
{{< gallery match="images/4/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny databasmapp med denna monteringssökväg "/calibre".
{{< gallery match="images/5/*.png" >}}
Jag tilldelar Calibre-behållaren fasta portar. Utan fasta portar kan det vara så att Calibre körs på en annan port efter en omstart.
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Calibre startas!
{{< gallery match="images/7/*.png" >}}
Jag ringer nu upp min Synology IP med den tilldelade Calibre-porten och ser följande bild. Jag anger "/calibre" som "Plats för Calibre-databasen". De övriga inställningarna är en fråga om smak.
{{< gallery match="images/8/*.png" >}}
Standardinloggningen är "admin" med lösenordet "admin123".
{{< gallery match="images/9/*.png" >}}
Klart! Naturligtvis kan jag nu också ansluta skrivbordsappen via min "bokmapp". Jag byter bibliotek i min app och väljer sedan min Nas-mapp.
{{< gallery match="images/10/*.png" >}}
Ungefär så här:
{{< gallery match="images/11/*.png" >}}
Om jag nu redigerar meta-infos i skrivbordsappen uppdateras de automatiskt även i webbappen.
{{< gallery match="images/12/*.png" >}}