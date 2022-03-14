+++
date = "2021-04-16"
title = "Kreativní východisko z krize: rezervace služby se snadnými termíny"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.cs.md"
+++
Krize společnosti Corona tvrdě dopadá na poskytovatele služeb v Německu. Digitální nástroje a řešení mohou pomoci překonat pandemii Corony co nejbezpečněji. V této sérii návodů "Kreativní z krize" ukazuji technologie nebo nástroje, které mohou být užitečné pro malé podniky.Dnes ukazuji "Easyappointments", nástroj pro rezervaci služeb, například kadeřnictví nebo obchodů. Služba Easyappointments se skládá ze dvou oblastí:
## Oblast 1: Backend
"Backend" pro správu služeb a schůzek.
{{< gallery match="images/1/*.png" >}}

## Oblast 2: Frontend
Nástroj pro koncové uživatele k rezervaci schůzek. Všechny již rezervované termíny jsou pak zablokovány a nelze je rezervovat dvakrát.
{{< gallery match="images/2/*.png" >}}

## Instalace
Aplikaci Easyappointments jsem již několikrát nainstaloval pomocí nástroje Docker-Compose a mohu tento způsob instalace vřele doporučit. Na serveru vytvořím nový adresář s názvem "easyappointments":
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Pak přejdu do adresáře easyappointments a vytvořím nový soubor s názvem "easyappointments.yml" s následujícím obsahem:
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Tento soubor se spouští pomocí nástroje Docker Compose. Poté je instalace přístupná pod určenou doménou/portem.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Vytvoření služby
Služby lze vytvořit v části "Služby". Každá nová služba pak musí být přiřazena poskytovateli/uživateli služby. To znamená, že si mohu objednat specializované zaměstnance nebo poskytovatele služeb.
{{< gallery match="images/3/*.png" >}}
Koncový spotřebitel si také může vybrat službu a preferovaného poskytovatele služeb.
{{< gallery match="images/4/*.png" >}}

## Pracovní doba a přestávky
Obecnou pracovní dobu lze nastavit v části "Nastavení" > "Obchodní logika". Pracovní dobu poskytovatelů služeb/uživatelů však lze změnit i v "Pracovním plánu" uživatele.
{{< gallery match="images/5/*.png" >}}

## Přehled rezervací a diář
V kalendáři schůzek jsou viditelné všechny rezervace. Rezervace lze samozřejmě vytvářet nebo upravovat také zde.
{{< gallery match="images/6/*.png" >}}

## Barevné nebo logické úpravy
Pokud zkopírujete adresář "/app/www" a zahrnete jej jako "svazek", můžete soubory stylů a logiku upravit podle svých představ.
{{< gallery match="images/7/*.png" >}}