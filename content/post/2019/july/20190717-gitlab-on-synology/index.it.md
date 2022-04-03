+++
date = "2019-07-17"
title = "Synology Nas: installare Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.it.md"
+++
Qui mostro come ho installato Gitlab e un runner Gitlab sul mio Synology NAS. Innanzitutto, l'applicazione GitLab deve essere installata come pacchetto Synology. Cerca "Gitlab" nel "Centro Pacchetti" e clicca su "Installa".   
{{< gallery match="images/1/*.*" >}}
Il servizio ascolta la porta "30000" per me. Quando tutto ha funzionato, richiamo il mio Gitlab con http://SynologyHostName:30000 e vedo questa immagine:
{{< gallery match="images/2/*.*" >}}
Quando accedo per la prima volta, mi viene chiesta la futura password "admin". È stato così! Ora posso organizzare i progetti. Ora è possibile installare un runner di Gitlab.  
{{< gallery match="images/3/*.*" >}}

