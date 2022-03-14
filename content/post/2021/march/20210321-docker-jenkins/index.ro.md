+++
date = "2021-03-21"
title = "Lucruri grozave cu containere: Rularea Jenkins pe Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.ro.md"
+++

## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Pregătiți dosarul Docker
Creez un nou director numit "jenkins" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Apoi mă mut în noul director și creez un nou dosar "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
De asemenea, am creat un fișier numit "jenkins.yml" cu următorul conținut. Partea frontală a portului "8081:" poate fi reglată.
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

## Pasul 3: Start
De asemenea, în această etapă pot utiliza consola. Pornesc serverul Jenkins prin Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
După aceea, pot apela serverul Jenkins cu IP-ul stației de disc și portul atribuit de la "Pasul 2".
{{< gallery match="images/4/*.png" >}}

## Pasul 4: Configurarea

{{< gallery match="images/5/*.png" >}}
Din nou, folosesc consola pentru a citi parola inițială:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
A se vedea:
{{< gallery match="images/6/*.png" >}}
Am selectat "Instalare recomandată".
{{< gallery match="images/7/*.png" >}}

## Pasul 5: Primul meu loc de muncă
Mă loghez și îmi creez sarcina Docker.
{{< gallery match="images/8/*.png" >}}
După cum puteți vedea, totul funcționează foarte bine!
{{< gallery match="images/9/*.png" >}}