+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner în Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.ro.md"
+++
Cum instalez un Gitlab runner ca un container Docker pe Synology NAS?
## Pasul 1: Căutați imaginea Docker
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut Gitlab. Selectez imaginea Docker "gitlab/gitlab-runner" și apoi selectez eticheta "bleeding".
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Puneți imaginea în funcțiune:

##  Problema gazdelor
Sinologia-gitlab-insterlation se identifică întotdeauna doar prin numele de gazdă. Deoarece am luat pachetul original Synology Gitlab din centrul de pachete, acest comportament nu poate fi modificat ulterior.  Ca o soluție alternativă, pot include propriul meu fișier hosts. Aici puteți vedea că numele de gazdă "peter" aparține adresei IP Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Acest fișier este pur și simplu stocat pe Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Pasul 3: Configurați GitLab Runner
Fac clic pe imaginea alergătorului meu:
{{< gallery match="images/3/*.png" >}}
Activez setarea "Enable automatic restart":
{{< gallery match="images/4/*.png" >}}
Apoi fac clic pe "Setări avansate" și selectez fila "Volum":
{{< gallery match="images/5/*.png" >}}
Fac clic pe Add file (Adaugă fișier) și includ fișierul meu hosts prin intermediul căii "/etc/hosts". Acest pas este necesar numai dacă numele de gazdă nu pot fi rezolvate.
{{< gallery match="images/6/*.png" >}}
Accept setările și fac clic pe next.
{{< gallery match="images/7/*.png" >}}
Acum găsesc imaginea inițializată în Container:
{{< gallery match="images/8/*.png" >}}
Selectez containerul (în cazul meu, gitlab-gitlab-runner2) și fac clic pe "Detalii". Apoi fac clic pe fila "Terminal" și creez o nouă sesiune bash. Aici introduc comanda "gitlab-runner register". Pentru înregistrare, am nevoie de informații pe care le pot găsi în instalația mea GitLab la http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Dacă aveți nevoie de mai multe pachete, le puteți instala prin "apt-get update" și apoi "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
După aceea, pot să includ culoarul în proiectele mele și să îl folosesc:
{{< gallery match="images/11/*.png" >}}