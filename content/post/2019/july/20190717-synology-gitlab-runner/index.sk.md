+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner v kontajneri Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.sk.md"
+++
Ako nainštalujem spúšťač Gitlab ako kontajner Docker na Synology NAS?
## Krok 1: Vyhľadanie obrazu aplikácie Docker
V okne Synology Docker kliknem na kartu Registrácia a vyhľadám Gitlab. Vyberiem obraz Docker "gitlab/gitlab-runner" a potom vyberiem značku "bleeding".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Uvedenie obrazu do prevádzky:

##  Problém hostiteľov
Môj synology-gitlab-insterlation sa vždy identifikuje len podľa názvu hostiteľa. Keďže som prevzal pôvodný balík Synology Gitlab z centra balíkov, toto správanie sa už nedá zmeniť.  Ako riešenie môžem zahrnúť vlastný súbor hosts. Tu vidíte, že názov hostiteľa "peter" patrí k IP adrese 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Tento súbor je jednoducho uložený v zariadení Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Nastavenie programu GitLab Runner
Kliknem na svoj obrázok bežca:
{{< gallery match="images/3/*.png" >}}
Aktivujem nastavenie "Povoliť automatický reštart":
{{< gallery match="images/4/*.png" >}}
Potom kliknem na položku "Rozšírené nastavenia" a vyberiem kartu "Hlasitosť":
{{< gallery match="images/5/*.png" >}}
Kliknem na Pridať súbor a zahrniem svoj súbor hosts cez cestu "/etc/hosts". Tento krok je potrebný len v prípade, že názvy hostiteľov nie je možné preložiť.
{{< gallery match="images/6/*.png" >}}
Prijmem nastavenia a kliknem na ďalšie.
{{< gallery match="images/7/*.png" >}}
Teraz nájdem inicializovaný obrázok v časti Kontajner:
{{< gallery match="images/8/*.png" >}}
Vyberiem kontajner (pre mňa gitlab-gitlab-runner2) a kliknem na "Podrobnosti". Potom kliknem na kartu "Terminál" a vytvorím novú reláciu bash. Tu zadám príkaz "gitlab-runner register". Na registráciu potrebujem informácie, ktoré nájdem v inštalácii GitLabu na adrese http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Ak potrebujete ďalšie balíky, môžete ich nainštalovať pomocou príkazu "apt-get update" a potom "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Potom môžem bežec zahrnúť do svojich projektov a používať ho:
{{< gallery match="images/11/*.png" >}}