+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner v zabojniku Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.sl.md"
+++
Kako namestim izvajalca Gitlab kot vsebnik Docker v strežnik Synology NAS?
## Korak 1: Iskanje slike Docker
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem Gitlab. Izberem sliko Docker "gitlab/gitlab-runner" in nato izberem oznako "bleeding".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Sliko uporabite v praksi:

##  Težava gostiteljev
Moja sinologija-gitlab-insterlation se vedno identificira samo z imenom gostitelja. Ker sem izvirni paket Synology Gitlab vzel iz središča za pakete, tega vedenja ni mogoče naknadno spremeniti.  Kot rešitev lahko vključim svojo datoteko hosts. Tukaj lahko vidite, da ime gostitelja "peter" pripada naslovu Nas IP 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Ta datoteka je preprosto shranjena v strežniku Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Korak 3: Nastavitev programa GitLab Runner
Kliknem na svojo sliko tekača:
{{< gallery match="images/3/*.png" >}}
Vključim nastavitev "Omogoči samodejni ponovni zagon":
{{< gallery match="images/4/*.png" >}}
Nato kliknem na "Napredne nastavitve" in izberem zavihek "Obseg":
{{< gallery match="images/5/*.png" >}}
Kliknem na Dodaj datoteko in vključim datoteko gostiteljev prek poti "/etc/hosts". Ta korak je potreben le, če gostiteljskih imen ni mogoče razrešiti.
{{< gallery match="images/6/*.png" >}}
Sprejmem nastavitve in kliknem na naslednji.
{{< gallery match="images/7/*.png" >}}
Zdaj najdem inicializirano sliko v razdelku Zabojnik:
{{< gallery match="images/8/*.png" >}}
Izberem vsebnik (pri meni je to gitlab-gitlab-runner2) in kliknem na "Podrobnosti". Nato kliknem na zavihek "Terminal" in ustvarim novo sejo bash. Tu vnesem ukaz "gitlab-runner register". Za registracijo potrebujem informacije, ki jih lahko najdem v svoji namestitvi GitLaba pod naslovom http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Če potrebujete več paketov, jih lahko namestite s "apt-get update" in nato "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Nato lahko tekač vključim v svoje projekte in ga uporabljam:
{{< gallery match="images/11/*.png" >}}