+++
date = "2021-04-25T09:28:11+01:00"
title = "Lyhyt tarina: Päivitä kontit automaattisesti Watchtowerin avulla"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.fi.md"
+++
Jos käytät Docker-kontteja levyasemallasi, haluat luonnollisesti, että ne ovat aina ajan tasalla. Watchtower päivittää kuvat ja kontit automaattisesti. Näin voit nauttia uusimmista ominaisuuksista ja ajantasaisimmasta tietoturvasta. Tänään näytän, miten Watchtower asennetaan Synologyn levyasemaan.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Asenna Watchtower
Käytän tähän konsolia:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Sen jälkeen Vartiotorni toimii aina taustalla.
{{< gallery match="images/3/*.png" >}}
