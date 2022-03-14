+++
date = "2021-04-18"
title = "Velké věci s kontejnery: Spuštění systému Docspell DMS na stanici Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-Docspell/index.cs.md"
+++
Docspell je systém pro správu dokumentů pro zařízení Synology DiskStation. Prostřednictvím služby Docspell lze dokumenty indexovat, vyhledávat a nacházet mnohem rychleji. Dnes ukážu, jak nainstalovat službu Docspell na diskovou stanici Synology.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Vytvoření složky Docspel
V adresáři Docker vytvořím nový adresář s názvem "docspell".
{{< gallery match="images/3/*.png" >}}
Nyní je třeba stáhnout následující soubor a rozbalit jej do adresáře: https://github.com/eikek/docspell/archive/refs/heads/master.zip . K tomu používám konzolu:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Poté upravím soubor "docker/docker-compose.yml" a do polí "consumedir" a "db" zadám adresy Synology:
{{< gallery match="images/4/*.png" >}}
Poté mohu spustit soubor Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Po několika minutách mohu zavolat svůj server Docspell s IP adresy diskové stanice a přiřazeným portem/7878.
{{< gallery match="images/5/*.png" >}}
