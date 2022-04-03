+++
date = "2019-07-17"
title = "Synology Nas: Instalați Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.ro.md"
+++
Aici vă arăt cum am instalat Gitlab și un Gitlab runner pe Synology NAS-ul meu. În primul rând, aplicația GitLab trebuie să fie instalată ca pachet Synology. Căutați "Gitlab" în "Package Centre" și faceți clic pe "Install".   
{{< gallery match="images/1/*.*" >}}
Serviciul ascultă portul "30000" pentru mine. Când totul a funcționat, am apelat Gitlab cu http://SynologyHostName:30000 și am văzut această imagine:
{{< gallery match="images/2/*.*" >}}
Atunci când mă conectez pentru prima dată, mi se cere parola "admin" din viitor. Asta a fost! Acum pot organiza proiecte. Acum poate fi instalat un Gitlab runner.  
{{< gallery match="images/3/*.*" >}}

