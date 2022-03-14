+++
date = "2020-02-13"
title = "Synology-Nas: Instalace Calibre Web jako knihovny elektronických knih"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.cs.md"
+++
Jak nainstaluji Calibre-Web jako kontejner Docker na zařízení Synology NAS? Pozor: Tento způsob instalace je zastaralý a není kompatibilní s aktuálním softwarem Calibre. Podívejte se prosím na tento nový návod:[Skvělé věci s kontejnery: Spouštění Calibre pomocí Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Skvělé věci s kontejnery: Spouštění Calibre pomocí Docker Compose"). Tento návod je určen všem profesionálům v oblasti Synology DS.
## Krok 1: Vytvoření složky
Nejprve vytvořím složku pro knihovnu Calibre.  Vyvolám "Ovládání systému" -> "Sdílená složka" a vytvořím novou složku "Knihy".
{{< gallery match="images/1/*.png" >}}

##  Krok 2: Vytvoření knihovny Calibre
Nyní zkopíruji existující knihovnu nebo "[tuto prázdnou ukázkovou knihovnu](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" do nového adresáře. Sám jsem zkopíroval stávající knihovnu desktopové aplikace.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Vyhledání obrazu nástroje Docker
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "Calibre". Vyberu obraz Docker "janeczku/calibre-web" a kliknu na značku "latest".
{{< gallery match="images/3/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Krok 4: Zprovozněte obrázek:
Dvakrát kliknu na svůj obrázek v Calibre.
{{< gallery match="images/4/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/calibre".
{{< gallery match="images/5/*.png" >}}
Kontejneru Calibre přiřadím pevné porty. Bez pevných portů by se mohlo stát, že Calibre po restartu poběží na jiném portu.
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze Calibre spustit!
{{< gallery match="images/7/*.png" >}}
Nyní vyvolám IP adresu Synology s přiřazeným portem Calibre a zobrazí se následující obrázek. Jako "Umístění databáze Calibre" zadám "/calibre". Ostatní nastavení jsou otázkou vkusu.
{{< gallery match="images/8/*.png" >}}
Výchozí přihlašovací jméno je "admin" s heslem "admin123".
{{< gallery match="images/9/*.png" >}}
Hotovo! Nyní mohu samozřejmě připojit i aplikaci pro stolní počítače prostřednictvím své "složky s knihami". V aplikaci vyměním knihovnu a pak vyberu složku Nas.
{{< gallery match="images/10/*.png" >}}
Něco takového:
{{< gallery match="images/11/*.png" >}}
Pokud nyní upravím metainfo v desktopové aplikaci, automaticky se aktualizují i ve webové aplikaci.
{{< gallery match="images/12/*.png" >}}