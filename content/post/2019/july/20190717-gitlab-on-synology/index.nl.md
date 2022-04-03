+++
date = "2019-07-17"
title = "Synology Nas: Gitlab installeren?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.nl.md"
+++
Hier laat ik zien hoe ik Gitlab en een Gitlab runner op mijn Synology NAS heb geïnstalleerd. Eerst moet de GitLab applicatie als Synology pakket geïnstalleerd worden. Zoek naar "Gitlab" in het "Pakketcentrum" en klik op "Installeren".   
{{< gallery match="images/1/*.*" >}}
De service luistert naar poort "30000" voor mij. Als alles gewerkt heeft, roep ik mijn Gitlab op met http://SynologyHostName:30000 en zie dit beeld:
{{< gallery match="images/2/*.*" >}}
Als ik voor de eerste keer inlog, wordt mij om het toekomstige "admin" wachtwoord gevraagd. Dat was het! Nu kan ik projecten organiseren. Nu kan een Gitlab runner geïnstalleerd worden.  
{{< gallery match="images/3/*.*" >}}

