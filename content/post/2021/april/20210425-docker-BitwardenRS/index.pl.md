+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS na serwerze Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.pl.md"
+++
Bitwarden to darmowa usługa open-source do zarządzania hasłami, która przechowuje poufne informacje, takie jak dane uwierzytelniające witryn internetowych w zaszyfrowanym skarbcu. Dzisiaj pokażę, jak zainstalować BitwardenRS na stacji Synology DiskStation.
## Krok 1: Przygotuj folder BitwardenRS
Tworzę nowy katalog o nazwie "bitwarden" w katalogu Docker.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj BitwardenRS
Klikam na zakładkę "Rejestracja" w oknie Synology Docker i wyszukuję "bitwarden". Wybieram obraz Docker "bitwardenrs/server", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Klikam dwukrotnie na obrazek mojego bitwardenrs. Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj.
{{< gallery match="images/3/*.png" >}}
Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder z tą ścieżką montowania "/data".
{{< gallery match="images/4/*.png" >}}
Przydzielam stałe porty dla kontenera "bitwardenrs". Bez ustalonych portów, może być tak, że "serwer bitwardenrs" działa na innym porcie po restarcie. Pierwszy port kontenera może zostać usunięty. Należy pamiętać o drugim porcie.
{{< gallery match="images/5/*.png" >}}
Kontener może być teraz uruchomiony. Wzywam serwer bitwardenrs podając adres IP Synology i port kontenera 8084.
{{< gallery match="images/6/*.png" >}}

## Krok 3: Skonfiguruj HTTPS
Klikam na "Panel sterowania" > "Reverse Proxy" i "Create".
{{< gallery match="images/7/*.png" >}}
Następnie mogę połączyć się z serwerem bitwardenrs, podając adres IP Synology i mój port proxy 8085, szyfrowany.
{{< gallery match="images/8/*.png" >}}