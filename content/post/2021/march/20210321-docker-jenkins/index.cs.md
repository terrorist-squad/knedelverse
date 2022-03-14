+++
date = "2021-03-21"
title = "Skvělé věci s kontejnery: Spuštění nástroje Jenkins na zařízení Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.cs.md"
+++

## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Příprava složky Docker
V adresáři Docker vytvořím nový adresář s názvem "jenkins".
{{< gallery match="images/3/*.png" >}}
Pak přejdu do nového adresáře a vytvořím novou složku "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Vytvářím také soubor s názvem "jenkins.yml" s následujícím obsahem. Přední část portu "8081:" lze nastavit.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Krok 3: Spuštění
V tomto kroku mohu také dobře využít konzolu. Server Jenkins spouštím pomocí nástroje Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Poté mohu zavolat svůj server Jenkins pomocí IP adresy diskové stanice a přiřazeného portu z kroku 2.
{{< gallery match="images/4/*.png" >}}

## Krok 4: Nastavení

{{< gallery match="images/5/*.png" >}}
Opět používám konzolu k přečtení počátečního hesla:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Viz:
{{< gallery match="images/6/*.png" >}}
Vybral jsem možnost "Doporučená instalace".
{{< gallery match="images/7/*.png" >}}

## Krok 5: Moje první zaměstnání
Přihlásím se a vytvořím úlohu Docker.
{{< gallery match="images/8/*.png" >}}
Jak vidíte, vše funguje skvěle!
{{< gallery match="images/9/*.png" >}}