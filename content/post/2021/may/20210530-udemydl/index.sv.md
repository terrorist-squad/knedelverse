+++
date = "2021-05-30"
title = "Udemy Downloader på Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-udemydl/index.sv.md"
+++
I den här handledningen lär du dig hur du laddar ner udemy-kurser för att använda dem offline.
## Steg 1: Förbered Udemy-mappen
Jag skapar en ny katalog som heter "udemy" i Dockerkatalogen.
{{< gallery match="images/1/*.png" >}}

## Steg 2: Installera Ubuntu-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "ubunutu". Jag väljer Docker-avbildningen "ubunutu" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
Jag dubbelklickar på min Ubuntu-avbildning. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/3/*.png" >}}
Jag väljer fliken "Volym" och klickar på "Lägg till mapp". Där skapar jag en ny mapp med denna monteringssökväg "/download".
{{< gallery match="images/4/*.png" >}}
Nu kan behållaren startas
{{< gallery match="images/5/*.png" >}}

## Steg 4: Installera Udemy Downloader
Jag klickar på "Container" i Synology Docker-fönstret och dubbelklickar på min "Udemy container". Sedan klickar jag på fliken "Terminal" och skriver in följande kommandon.
{{< gallery match="images/6/*.png" >}}

##  Kommandon:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Skärmdumpar:
{{< gallery match="images/7/*.png" >}}

## Steg 4: Sätt Udemy-downloader i drift
Nu behöver jag en "access token". Jag besöker Udemy med min webbläsare Firefox och öppnar Firebug. Jag klickar på fliken "Web storage" och kopierar "Access token".
{{< gallery match="images/8/*.png" >}}
Jag skapar en ny fil i min behållare:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Därefter kan jag ladda ner de kurser jag redan har köpt:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Se:
{{< gallery match="images/9/*.png" >}}
