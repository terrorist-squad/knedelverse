+++
date = "2021-04-11"
title = "Lyhyt tarina: Synologyn volyymien liittäminen ESXiin."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.fi.md"
+++

## Vaihe 1: Aktivoi "NFS"-palvelu.
Ensin NFS-palvelu on aktivoitava levyasemalla. Tätä varten menen "Ohjauspaneeli" > "Tiedostopalvelut" -asetukseen ja napsautan "Ota NFS käyttöön".
{{< gallery match="images/1/*.png" >}}
Sitten klikkaan "Jaettu kansio" ja valitsen hakemiston.
{{< gallery match="images/2/*.png" >}}

## Vaihe 2: Kiinnitä hakemistot ESXi:ssä
Napsautan ESXissä "Storage" > "New datastore" ja syötän tietoni sinne.
{{< gallery match="images/3/*.png" >}}

## Valmis
Nyt muistia voidaan käyttää.
{{< gallery match="images/4/*.png" >}}
Testausta varten asensin DOS-asennuksen ja vanhan kirjanpito-ohjelmiston tämän kiinnityspisteen kautta.
{{< gallery match="images/5/*.png" >}}
