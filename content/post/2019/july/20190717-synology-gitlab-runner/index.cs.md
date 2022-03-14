+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner v kontejneru Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.cs.md"
+++
Jak nainstaluji spouštěcí program Gitlab jako kontejner Docker na zařízení Synology NAS?
## Krok 1: Vyhledání bitové kopie nástroje Docker
V okně Synology Docker kliknu na kartu Registrace a vyhledám Gitlab. Vyberu obraz Docker "gitlab/gitlab-runner" a poté vyberu značku "bleeding".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zprovozněte obrázek:

##  Problém hostitelů
Můj synology-gitlab-insterlation se vždy identifikuje pouze jménem hostitele. Protože jsem z centra balíčků převzal původní balíček Synology Gitlab, nelze toto chování dodatečně změnit.  Jako řešení mohu zahrnout svůj vlastní soubor hosts. Zde vidíte, že název hostitele "peter" patří k adrese Nas IP 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Tento soubor je jednoduše uložen v zařízení Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Nastavení programu GitLab Runner
Kliknu na obrázek svého běžce:
{{< gallery match="images/3/*.png" >}}
Aktivuji nastavení "Povolit automatický restart":
{{< gallery match="images/4/*.png" >}}
Poté kliknu na "Rozšířená nastavení" a vyberu kartu "Hlasitost":
{{< gallery match="images/5/*.png" >}}
Kliknu na Přidat soubor a zahrnu svůj soubor hosts přes cestu "/etc/hosts". Tento krok je nutný pouze v případě, že názvy hostitelů nelze přeložit.
{{< gallery match="images/6/*.png" >}}
Přijímám nastavení a klikám na další.
{{< gallery match="images/7/*.png" >}}
Nyní najdu inicializovaný obraz v části Kontejner:
{{< gallery match="images/8/*.png" >}}
Vyberu kontejner (pro mě gitlab-gitlab-runner2) a kliknu na "Podrobnosti". Pak kliknu na kartu "Terminál" a vytvořím novou relaci bashe. Zde zadám příkaz "gitlab-runner register". Pro registraci potřebuji informace, které najdu v instalaci GitLabu pod adresou http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Pokud potřebujete další balíčky, můžete je nainstalovat pomocí příkazu "apt-get update" a poté "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Poté mohu běhoun zahrnout do svých projektů a používat ho:
{{< gallery match="images/11/*.png" >}}