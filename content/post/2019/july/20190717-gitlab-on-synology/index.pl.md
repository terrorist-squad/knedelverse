+++
date = "2019-07-17"
title = "Synology Nas: Zainstalować Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.pl.md"
+++
Tutaj pokazuję, jak zainstalowałem Gitlab i program uruchamiający Gitlab na serwerze NAS firmy Synology. Najpierw należy zainstalować aplikację GitLab jako pakiet Synology. Wyszukaj "Gitlab" w "Centrum pakietów" i kliknij "Zainstaluj".   
{{< gallery match="images/1/*.*" >}}
W moim przypadku usługa nasłuchuje na porcie "30000". Gdy wszystko działa, wywołuję Gitlab z witryny http://SynologyHostName:30000 i widzę taki oto obrazek:
{{< gallery match="images/2/*.*" >}}
Gdy loguję się po raz pierwszy, jestem proszony o podanie przyszłego hasła "admin". To było to! Teraz mogę organizować projekty. Teraz można zainstalować program uruchamiający Gitlab.  
{{< gallery match="images/3/*.*" >}}

