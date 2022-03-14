+++
date = "2019-07-17"
title = "Synology Nas: Inštalácia aplikácie Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.sk.md"
+++
Tu ukazujem, ako som nainštaloval Gitlab a Gitlab runner na Synology NAS. Najprv je potrebné nainštalovať aplikáciu GitLab ako balík Synology. Vyhľadajte "Gitlab" v "Centre balíčkov" a kliknite na "Inštalovať".   
{{< gallery match="images/1/*.*" >}}
Služba počúva port "30000" pre mňa. Keď všetko funguje, zavolám svoj Gitlab s http://SynologyHostName:30000 a vidím tento obrázok:
{{< gallery match="images/2/*.*" >}}
Keď sa prvýkrát prihlásim, som požiadaný o budúce heslo "admin". To bolo všetko! Teraz môžem organizovať projekty. Teraz je možné nainštalovať spúšťač Gitlab.  
{{< gallery match="images/3/*.*" >}}
