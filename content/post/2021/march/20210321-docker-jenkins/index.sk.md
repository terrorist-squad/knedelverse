+++
date = "2021-03-21"
title = "Veľké veci s kontajnermi: Spustenie aplikácie Jenkins na zariadení Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.sk.md"
+++

## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Príprava priečinka Docker
V adresári Docker vytvorím nový adresár s názvom "jenkins".
{{< gallery match="images/3/*.png" >}}
Potom prejdem do nového adresára a vytvorím nový priečinok "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Vytvoril som tiež súbor s názvom "jenkins.yml" s nasledujúcim obsahom. Prednú časť portu "8081:" možno nastaviť.
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

## Krok 3: Spustenie
V tomto kroku môžem tiež dobre využiť konzolu. Server Jenkins spúšťam prostredníctvom nástroja Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Potom môžem zavolať svoj server Jenkins pomocou IP adresy diskovej stanice a priradeného portu z kroku 2.
{{< gallery match="images/4/*.png" >}}

## Krok 4: Nastavenie

{{< gallery match="images/5/*.png" >}}
Opäť použijem konzolu na prečítanie počiatočného hesla:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Pozri:
{{< gallery match="images/6/*.png" >}}
Vybral som možnosť "Odporúčaná inštalácia".
{{< gallery match="images/7/*.png" >}}

## Krok 5: Moja prvá práca
Prihlásim sa a vytvorím úlohu Docker.
{{< gallery match="images/8/*.png" >}}
Ako vidíte, všetko funguje skvele!
{{< gallery match="images/9/*.png" >}}
