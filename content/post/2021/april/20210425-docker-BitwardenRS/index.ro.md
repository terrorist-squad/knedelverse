+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS pe Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.ro.md"
+++
Bitwarden este un serviciu gratuit de gestionare a parolelor cu sursă deschisă care stochează informații confidențiale, cum ar fi datele de identificare ale site-urilor web, într-un seif criptat. Astăzi vă arăt cum să instalați un BitwardenRS pe Synology DiskStation.
## Pasul 1: Pregătiți dosarul BitwardenRS
Creez un nou director numit "bitwarden" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalați BitwardenRS
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "bitwarden". Selectez imaginea Docker "bitwardenrs/server" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
Dau dublu clic pe imaginea mea de bitwardenrs. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/3/*.png" >}}
Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/data".
{{< gallery match="images/4/*.png" >}}
Atribui porturi fixe pentru containerul "bitwardenrs". Fără porturi fixe, s-ar putea ca "serverul bitwardenrs" să ruleze pe un port diferit după o repornire. Primul port container poate fi șters. Celălalt port trebuie reținut.
{{< gallery match="images/5/*.png" >}}
Containerul poate fi pornit acum. Am apelat serverul bitwardenrs cu adresa IP a Synology și portul 8084 al containerului meu.
{{< gallery match="images/6/*.png" >}}

## Pasul 3: Configurați HTTPS
Am făcut clic pe "Control Panel" > "Reverse Proxy" și "Create".
{{< gallery match="images/7/*.png" >}}
După aceea, pot apela serverul bitwardenrs cu adresa IP a Synology și portul meu proxy 8085, criptat.
{{< gallery match="images/8/*.png" >}}