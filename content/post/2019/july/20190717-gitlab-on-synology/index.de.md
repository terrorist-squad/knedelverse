+++
date = "2019-07-17"
title = "Synology Nas: Gitlab installieren?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.de.md"
+++

Hier zeige ich wie ich Gitlab und einen Gitlab-Runner auf meinen Synology-Nas installiert habe. Zunächst muss die GitLab-Applikation als Synology-Paket installiert werden. Suchen Sie nach “Gitlab” im “Paket-Zentrum” und klicken Sie auf “Installieren”.   
{{< gallery match="images/1/*.*" >}}


Der Dienst hört bei mir auf den Port “30000”. Wenn alles geklappt hat, rufe ich mein Gitlab mit http://SynologyHostName:30000 auf und sehen dieses Bild:  
{{< gallery match="images/2/*.*" >}}

Bei der ersten Anmeldung werde ich nach dem zukünftigen “Admin”-Password gefragt. Das war es auch schon! Jetzt kann ich Projekte Organisieren. Nun kann ein Gitlab-Runner installiert werden.  
{{< gallery match="images/3/*.*" >}}
