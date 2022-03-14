+++
date = "2020-02-21"
title = "Skvělé věci s kontejnery: Spuštění Calibre s Docker Compose (nastavení Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.cs.md"
+++
Na tomto blogu již existuje jednodušší návod: [Synology-Nas: Instalace Calibre Web jako knihovny elektronických knih]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Instalace Calibre Web jako knihovny elektronických knih"). Tento návod je určen všem profesionálům v oblasti Synology DS.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Vytvoření složky s knihami
Vytvořím novou složku pro knihovnu Calibre. To provedu tak, že vyvolám "Ovládání systému" -> "Sdílená složka" a vytvořím novou složku s názvem "Knihy". Pokud složka "Docker" ještě neexistuje, je třeba ji také vytvořit.
{{< gallery match="images/3/*.png" >}}

## Krok 3: Příprava složky s knihou
Nyní je třeba stáhnout a rozbalit následující soubor: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Obsah ("metadata.db") musí být umístěn v novém adresáři knihy, viz:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Příprava složky Docker
V adresáři Docker vytvořím nový adresář s názvem "calibre":
{{< gallery match="images/5/*.png" >}}
Poté přejdu do nového adresáře a vytvořím nový soubor s názvem "calibre.yml" s následujícím obsahem:
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
V tomto novém souboru je třeba upravit několik míst takto: * PUID/PGID: V poli PUID/PGID je třeba zadat ID uživatele a skupiny uživatele DS. Zde použiji konzolu z "kroku 1" a příkaz "id -u" pro zobrazení ID uživatele. Příkazem "id -g" získám ID skupiny.* porty: U portu je třeba upravit přední část "8055:".adresářeVšechny adresáře v tomto souboru je třeba opravit. Správné adresy lze zjistit v okně vlastností DS. (Následuje snímek obrazovky)
{{< gallery match="images/6/*.png" >}}

## Krok 5: Testovací spuštění
V tomto kroku mohu také dobře využít konzolu. Přepnu se do adresáře Calibre a spustím tam server Calibre pomocí nástroje Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Krok 6: Nastavení
Pak mohu zavolat svůj server Calibre pomocí IP adresy diskové stanice a přiřazeného portu z kroku 4. V nastavení používám přípojný bod "/books". Poté je již server použitelný.
{{< gallery match="images/8/*.png" >}}

## Krok 7: Dokončení nastavení
V tomto kroku je také zapotřebí konzola. K uložení databáze vnitřní aplikace kontejneru používám příkaz "exec".
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Poté se v adresáři Calibre objeví nový soubor "app.db":
{{< gallery match="images/9/*.png" >}}
Poté zastavím server Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Nyní změním cestu ke schránce a přetrvává nad ní databáze aplikace.
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
Poté lze server restartovat:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}