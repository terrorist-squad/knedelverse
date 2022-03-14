+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner in Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.nl.md"
+++
Hoe installeer ik een Gitlab runner als een Docker container op mijn Synology NAS?
## Stap 1: Zoek naar Docker image
Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar Gitlab. Ik selecteer de Docker image "gitlab/gitlab-runner" en selecteer dan de tag "bleeding".
{{< gallery match="images/1/*.png" >}}

## Stap 2: Zet het beeld in werking:

##  Hosts probleem
Mijn synologie-gitlab-insterlatie identificeert zichzelf altijd alleen met hostnaam. Aangezien ik het originele Synology Gitlab pakket uit het pakketcentrum heb gehaald, kan dit gedrag achteraf niet worden gewijzigd.  Als een workaround, kan ik mijn eigen hosts bestand toevoegen. Hier kunt u zien dat de hostnaam "peter" hoort bij het Nas IP adres 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Dit bestand wordt gewoon opgeslagen op de Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Stap 3: GitLab Runner instellen
Ik klik op de foto van mijn loper:
{{< gallery match="images/3/*.png" >}}
Ik activeer de instelling "Automatisch herstarten inschakelen":
{{< gallery match="images/4/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en selecteer het tabblad "Volume":
{{< gallery match="images/5/*.png" >}}
Ik klik op Bestand toevoegen en voeg mijn hosts bestand toe via het pad "/etc/hosts". Deze stap is alleen nodig als de hostnamen niet kunnen worden opgelost.
{{< gallery match="images/6/*.png" >}}
Ik accepteer de instellingen en klik op volgende.
{{< gallery match="images/7/*.png" >}}
Nu vind ik de geïnitialiseerde afbeelding onder Container:
{{< gallery match="images/8/*.png" >}}
Ik selecteer de container (gitlab-gitlab-runner2 voor mij) en klik op "Details". Dan klik ik op de "Terminal" tab en maak een nieuwe bash sessie aan. Hier voer ik het commando "gitlab-runner register" in. Voor de registratie heb ik informatie nodig die ik kan vinden in mijn GitLab installatie onder http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Als je meer pakketten nodig hebt, kun je ze installeren via "apt-get update" en dan "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Daarna kan ik de loper in mijn projecten opnemen en gebruiken:
{{< gallery match="images/11/*.png" >}}