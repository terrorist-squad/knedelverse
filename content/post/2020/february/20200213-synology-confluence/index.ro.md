+++
date = "2020-02-13"
title = "Synology-Nas: Confluence ca un sistem wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.ro.md"
+++
Dacă doriți să instalați Atlassian Confluence pe un NAS Synology, atunci ați ajuns la locul potrivit.
## Pasul 1
În primul rând, deschid aplicația Docker în interfața Synology și apoi merg la subpunctul "Înregistrare". Acolo caut "Confluence" și fac clic pe prima imagine "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Pasul 2
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Repornire automată
Fac dublu clic pe imaginea mea Confluence.
{{< gallery match="images/2/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată".
{{< gallery match="images/3/*.png" >}}

## Porturi
Atribui porturi fixe pentru containerul Confluence. Fără porturi fixe, Confluence ar putea rula pe un port diferit după o repornire.
{{< gallery match="images/4/*.png" >}}

## Memorie
Creez un folder fizic și îl montez în container (/var/atlassian/application-data/confluence/). Această setare facilitează salvarea și restaurarea datelor.
{{< gallery match="images/5/*.png" >}}
După aceste setări, Confluence poate fi pornit!
{{< gallery match="images/6/*.png" >}}