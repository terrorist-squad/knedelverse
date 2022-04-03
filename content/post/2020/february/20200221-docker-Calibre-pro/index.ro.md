+++
date = "2020-02-21"
title = "Lucruri grozave cu containere: Rularea Calibre cu Docker Compose (configurare Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.ro.md"
+++
Există deja un tutorial mai ușor pe acest blog: [Synology-Nas: Instalați Calibre Web ca o bibliotecă de cărți electronice]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Instalați Calibre Web ca o bibliotecă de cărți electronice"). Acest tutorial se adresează tuturor profesioniștilor Synology DS.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Creați un dosar de cărți
Creez un nou dosar pentru biblioteca Calibre. Pentru a face acest lucru, apelez la "System Control" -> "Shared Folder" și creez un nou dosar numit "Books". Dacă nu există încă un dosar "Docker", atunci trebuie creat și acesta.
{{< gallery match="images/3/*.png" >}}

## Pasul 3: Pregătiți dosarul de carte
Acum trebuie descărcat și despachetat următorul fișier: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Conținutul ("metadata.db") trebuie să fie plasat în noul director al cărții, a se vedea:
{{< gallery match="images/4/*.png" >}}

## Pasul 4: Pregătiți dosarul Docker
Creez un nou director numit "calibre" în directorul Docker:
{{< gallery match="images/5/*.png" >}}
Apoi mă mut în noul director și creez un nou fișier numit "calibre.yml" cu următorul conținut:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
În acest nou fișier, mai multe locuri trebuie ajustate după cum urmează:* PUID/PGID: ID-ul de utilizator și de grup al utilizatorului DS trebuie introduse în PUID/PGID. Aici folosesc consola de la "Pasul 1" și comanda "id -u" pentru a vedea ID-ul utilizatorului. Cu comanda "id -g" obțin ID-ul grupului.* porturi: Pentru port, partea din față "8055:" trebuie să fie ajustată.directoareToate directoarele din acest fișier trebuie corectate. Adresele corecte pot fi văzute în fereastra de proprietăți a DS. (Urmează o captură de ecran)
{{< gallery match="images/6/*.png" >}}

## Pasul 5: Test de pornire
De asemenea, în această etapă pot utiliza consola. Mă mut în directorul Calibre și pornesc serverul Calibre de acolo prin Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Pasul 6: Configurare
Apoi, pot apela serverul Calibre cu IP-ul stației de disc și portul atribuit de la "Pasul 4". În configurare, folosesc punctul de montare "/books". După aceea, serverul este deja utilizabil.
{{< gallery match="images/8/*.png" >}}

## Etapa 7: Finalizarea configurației
Consola este, de asemenea, necesară în această etapă. Folosesc comanda "exec" pentru a salva baza de date a aplicației interne a containerului.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
După aceea, văd un nou fișier "app.db" în directorul Calibre:
{{< gallery match="images/9/*.png" >}}
Apoi opresc serverul Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Acum schimb calea letterbox și mențin baza de date a aplicației peste ea.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
După aceea, serverul poate fi repornit:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
