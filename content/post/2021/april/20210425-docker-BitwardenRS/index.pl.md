+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS na serwerze Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.pl.md"
+++
Bitwarden to bezpłatna usługa open-source do zarządzania hasłami, która przechowuje poufne informacje, takie jak dane uwierzytelniające witryn internetowych, w zaszyfrowanym skarbcu. Dzisiaj pokazuję, jak zainstalować BitwardenRS na serwerze Synology DiskStation.
## Krok 1: Przygotuj folder BitwardenRS
W katalogu Docker tworzę nowy katalog o nazwie "bitwarden".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj BitwardenRS
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "bitwarden". Wybieram obraz Docker "bitwardenrs/server", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Klikam dwukrotnie na obrazie bitwardenrs. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/3/*.png" >}}
Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/data".
{{< gallery match="images/4/*.png" >}}
Przydzielam stałe porty dla kontenera "bitwardenrs". Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu serwer bitwardenrs będzie działał na innym porcie. Pierwszy port kontenera można usunąć. Należy pamiętać o drugim porcie.
{{< gallery match="images/5/*.png" >}}
Teraz można uruchomić kontener. Wywołuję serwer bitwardenrs, podając adres IP Synology i port kontenera 8084.
{{< gallery match="images/6/*.png" >}}

## Krok 3: Skonfiguruj protokół HTTPS
Klikam na "Panel sterowania" > "Odwrócone proxy" i "Utwórz".
{{< gallery match="images/7/*.png" >}}
Następnie mogę połączyć się z serwerem bitwardenrs, podając adres IP Synology i mój port proxy 8085, po zaszyfrowaniu.
{{< gallery match="images/8/*.png" >}}
