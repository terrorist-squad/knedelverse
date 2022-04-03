+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Futó Docker konténerben"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.hu.md"
+++
Hogyan telepíthetek egy Gitlab futót Docker konténerként a Synology NAS-ra?
## 1. lépés: Docker-kép keresése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a Gitlabra. Kiválasztom a "gitlab/gitlab-runner" Docker-képet, majd kiválasztom a "bleeding" címkét.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Helyezze a képet működésbe:

##  Gazdák problémája
A synology-gitlab-insterlation mindig csak hostnévvel azonosítja magát. Mivel az eredeti Synology Gitlab csomagot a csomagközpontból vettem, ez a viselkedés utólag nem változtatható meg.  Megoldásként a saját hosts fájlomat is csatolhatom. Itt látható, hogy a "peter" állomásnév a 192.168.12.42 Nas IP-címhez tartozik.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Ez a fájl egyszerűen a Synology NAS-on tárolódik.
{{< gallery match="images/2/*.png" >}}

## 3. lépés: A GitLab Runner beállítása
A Runner képemre kattintok:
{{< gallery match="images/3/*.png" >}}
Aktiválom az "Automatikus újraindítás engedélyezése" beállítást:
{{< gallery match="images/4/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és kiválasztom a "Hangerő" lapot:
{{< gallery match="images/5/*.png" >}}
A Fájl hozzáadása gombra kattintok, és a "/etc/hosts" elérési útvonalon keresztül beillesztem a hosts fájlomat. Erre a lépésre csak akkor van szükség, ha a hosztnevek nem oldhatók fel.
{{< gallery match="images/6/*.png" >}}
Elfogadom a beállításokat, és a következőre kattintok.
{{< gallery match="images/7/*.png" >}}
Most a Container alatt találom az inicializált képet:
{{< gallery match="images/8/*.png" >}}
Kiválasztom a konténert (nekem gitlab-gitlab-runner2), és a "Részletek" gombra kattintok. Ezután a "Terminal" fülre kattintok, és létrehozok egy új bash munkamenetet. Itt a "gitlab-runner register" parancsot adom meg. A regisztrációhoz olyan információkra van szükségem, amelyeket a GitLab telepítésemben találok a http://gitlab-adresse:port/admin/runners címen.   
{{< gallery match="images/9/*.png" >}}
Ha további csomagokra van szükséged, telepítheted őket az "apt-get update", majd az "apt-get install python ..." segítségével.
{{< gallery match="images/10/*.png" >}}
Ezután a futót beépíthetem a projektjeimbe és felhasználhatom:
{{< gallery match="images/11/*.png" >}}
