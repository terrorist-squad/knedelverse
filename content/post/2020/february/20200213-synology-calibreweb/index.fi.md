+++
date = "2020-02-13"
title = "Synology-Nas: Asenna Calibre Web e-kirjastoksi"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.fi.md"
+++
Miten asennan Calibre-Webin Docker-säiliönä Synology NAS -laitteeseeni? Huomio: Tämä asennusmenetelmä on vanhentunut eikä se ole yhteensopiva nykyisen Calibre-ohjelmiston kanssa. Tutustu tähän uuteen opetusohjelmaan:[Suuria asioita konttien avulla: Calibren käyttäminen Docker Composen kanssa]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Suuria asioita konttien avulla: Calibren käyttäminen Docker Composen kanssa"). Tämä opetusohjelma on tarkoitettu kaikille Synology DS -ammattilaisille.
## Vaihe 1: Luo kansio
Ensin luon kansion Calibre-kirjastolle.  Kutsun "Järjestelmän hallinta" -> "Jaettu kansio" ja luon uuden kansion "Kirjat".
{{< gallery match="images/1/*.png" >}}

##  Vaihe 2: Luo Calibre-kirjasto
Nyt kopioin olemassa olevan kirjaston tai "[tämä tyhjä esimerkkikirjasto](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" uuteen hakemistoon. Olen itse kopioinut työpöytäsovelluksen nykyisen kirjaston.
{{< gallery match="images/2/*.png" >}}

## Vaihe 3: Etsi Docker-kuva
Napsautan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "Calibre". Valitsen Docker-kuvan "janeczku/calibre-web" ja napsautan sitten tagia "latest".
{{< gallery match="images/3/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda säiliön kuvasta, on tehtävä muutamia asetuksia.
## Vaihe 4: Ota kuva käyttöön:
Kaksoisnapsautan Calibre-kuvaani.
{{< gallery match="images/4/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add Folder". Siellä luon uuden tietokantakansio, jossa on tämä liitäntäpolku "/calibre".
{{< gallery match="images/5/*.png" >}}
Määritän Calibre-säiliölle kiinteät portit. Ilman kiinteitä portteja voi olla, että Calibre toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Calibre voidaan käynnistää!
{{< gallery match="images/7/*.png" >}}
Soitan nyt Synologyn IP-osoitteen ja osoitetun Calibre-portin ja näen seuraavan kuvan. Kirjoitan "/calibre" "Calibre-tietokannan sijainniksi". Muut asetukset ovat makuasia.
{{< gallery match="images/8/*.png" >}}
Oletuskirjautuminen on "admin" ja salasana "admin123".
{{< gallery match="images/9/*.png" >}}
Valmis! Tietenkin voin nyt myös yhdistää työpöytäsovelluksen "kirjakansiossani". Vaihdan kirjaston sovelluksessani ja valitsen sitten Nas-kansion.
{{< gallery match="images/10/*.png" >}}
Jotain tällaista:
{{< gallery match="images/11/*.png" >}}
Jos nyt muokkaan meta-infoja työpöytäsovelluksessa, ne päivittyvät automaattisesti myös verkkosovelluksessa.
{{< gallery match="images/12/*.png" >}}