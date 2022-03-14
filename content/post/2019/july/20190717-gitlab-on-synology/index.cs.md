+++
date = "2019-07-17"
title = "Synology Nas: Nainstalovat Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-gitlab-on-synology/index.cs.md"
+++
Zde ukazuji, jak jsem nainstaloval Gitlab a Gitlab runner na svůj Synology NAS. Nejprve je třeba nainstalovat aplikaci GitLab jako balíček Synology. V Centru balíčků vyhledejte položku "Gitlab" a klikněte na tlačítko "Instalovat".   
{{< gallery match="images/1/*.*" >}}
Služba mi naslouchá na portu "30000". Když vše funguje, vyvolám Gitlab pomocí http://SynologyHostName:30000 a uvidím tento obrázek:
{{< gallery match="images/2/*.*" >}}
Při prvním přihlášení jsem požádán o budoucí heslo "admin". To bylo ono! Nyní mohu organizovat projekty. Nyní je možné nainstalovat běhové prostředí Gitlab.  
{{< gallery match="images/3/*.*" >}}
