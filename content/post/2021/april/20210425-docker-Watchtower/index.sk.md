+++
date = "2021-04-25T09:28:11+01:00"
title = "Krátky príbeh: Automatická aktualizácia kontajnerov pomocou Strážnej veže"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.sk.md"
+++
Ak na svojej diskovej stanici spúšťate kontajnery Docker, prirodzene chcete, aby boli vždy aktuálne. Strážna veža automaticky aktualizuje obrazy a kontajnery. Takto môžete využívať najnovšie funkcie a najmodernejšie zabezpečenie údajov. Dnes vám ukážem, ako nainštalovať strážnu vežu na diskovú stanicu Synology.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Inštalácia strážnej veže
Používam na to konzolu:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Potom Strážna veža vždy beží na pozadí.
{{< gallery match="images/3/*.png" >}}
