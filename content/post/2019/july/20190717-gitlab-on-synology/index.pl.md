+++
date = "2019-07-17"
title = "Synology Nas: Zainstalować Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-gitlab-on-synology/index.pl.md"
+++
Tutaj pokazuję, jak zainstalowałem Gitlab i program uruchamiający Gitlab na moim serwerze NAS firmy Synology. Po pierwsze, aplikacja GitLab musi zostać zainstalowana jako pakiet Synology. W "Centrum pakietów" wyszukać "Gitlab" i kliknąć na "Zainstaluj".   
{{< gallery match="images/1/*.*" >}}
Usługa nasłuchuje dla mnie na porcie "30000". Kiedy wszystko działa, wywołuję mój Gitlab z http://SynologyHostName:30000 i widzę ten obrazek:
{{< gallery match="images/2/*.*" >}}
Kiedy loguję się po raz pierwszy, jestem proszony o podanie przyszłego hasła "admin". To było to! Teraz mogę organizować projekty. Teraz można zainstalować program uruchamiający Gitlab.  
{{< gallery match="images/3/*.*" >}}
