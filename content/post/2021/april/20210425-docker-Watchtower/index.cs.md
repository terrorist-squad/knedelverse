+++
date = "2021-04-25T09:28:11+01:00"
title = "Stručný obsah: Automatická aktualizace kontejnerů pomocí Strážní věže"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.cs.md"
+++
Pokud na své diskové stanici provozujete kontejnery Docker, přirozeně chcete, aby byly vždy aktuální. Strážní věž automaticky aktualizuje obrazy a kontejnery. Můžete tak využívat nejnovější funkce a nejmodernější zabezpečení dat. Dnes vám ukážu, jak nainstalovat věž Watchtower na diskovou stanici Synology.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Instalace strážní věže
K tomu používám konzolu:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Poté je program Strážná věž vždy spuštěn na pozadí.
{{< gallery match="images/3/*.png" >}}
