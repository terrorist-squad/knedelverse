+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS Synology DiskStationissa"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.fi.md"
+++
Bitwarden on ilmainen avoimen lähdekoodin salasanojen hallintapalvelu, joka tallentaa luottamukselliset tiedot, kuten verkkosivustojen tunnukset, salattuun holviin. Tänään näytän, miten BitwardenRS asennetaan Synology DiskStationiin.
## Vaihe 1: BitwardenRS-kansion valmistelu
Luon Docker-hakemistoon uuden hakemiston nimeltä "bitwarden".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna BitwardenRS
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "bitwarden". Valitsen Docker-kuvan "bitwardenrs/server" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kaksoisnapsautan bitwardenrs-kuvaani. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös tässä.
{{< gallery match="images/3/*.png" >}}
Valitsen "Volume"-välilehden ja napsautan "Add Folder". Siellä luon uuden kansion, jossa on tämä liitäntäpolku "/data".
{{< gallery match="images/4/*.png" >}}
Määritän kiinteät portit "bitwardenrs"-säiliölle. Ilman kiinteitä portteja voi olla, että bitwardenrs-palvelin toimii eri portissa uudelleenkäynnistyksen jälkeen. Ensimmäinen konttisatama voidaan poistaa. Toinen satama olisi muistettava.
{{< gallery match="images/5/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun bitwardenrs-palvelinta Synologyn IP-osoitteella ja konttiportilla 8084.
{{< gallery match="images/6/*.png" >}}

## Vaihe 3: Määritä HTTPS
Napsautan "Ohjauspaneeli" > "Käänteinen välityspalvelin" ja "Luo".
{{< gallery match="images/7/*.png" >}}
Sen jälkeen voin soittaa bitwardenrs-palvelimelle Synologyn IP-osoitteella ja salatulla välitysportilla 8085.
{{< gallery match="images/8/*.png" >}}
