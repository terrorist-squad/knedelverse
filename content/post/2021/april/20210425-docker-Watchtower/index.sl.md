+++
date = "2021-04-25T09:28:11+01:00"
title = "Kratka zgodba: Samodejno posodabljanje zabojnikov s Stražnim stolpom"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.sl.md"
+++
Če na svoji diskovni postaji uporabljate vsebnike Docker, seveda želite, da so vedno posodobljeni. Program Watchtower samodejno posodablja slike in vsebnike. Tako lahko uporabljate najnovejše funkcije in najsodobnejšo varnost podatkov. Danes vam bom pokazal, kako namestiti stolp Watchtower na diskovno postajo Synology.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Namestitev stolpa Watchtower
Za to uporabljam konzolo:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Nato se program Watchtower vedno izvaja v ozadju.
{{< gallery match="images/3/*.png" >}}

