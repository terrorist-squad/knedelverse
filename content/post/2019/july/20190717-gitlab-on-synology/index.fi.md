+++
date = "2019-07-17"
title = "Synology Nas: Asenna Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.fi.md"
+++
Tässä näytän, miten asensin Gitlabin ja Gitlab-runnerin Synology NAS:iin. Ensin GitLab-sovellus on asennettava Synology-pakettina. Etsi "Gitlab" pakettikeskuksesta ja napsauta "Asenna".   
{{< gallery match="images/1/*.*" >}}
Palvelu kuuntelee porttia "30000" minun puolestani. Kun kaikki on toiminut, kutsun Gitlabin osoitteessa http://SynologyHostName:30000 ja näen tämän kuvan:
{{< gallery match="images/2/*.*" >}}
Kun kirjaudun sisään ensimmäistä kertaa, minulta kysytään tulevaa "admin"-salasanaa. Se oli siinä! Nyt voin organisoida hankkeita. Nyt Gitlab-runner voidaan asentaa.  
{{< gallery match="images/3/*.*" >}}
