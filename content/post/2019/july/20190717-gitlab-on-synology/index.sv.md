+++
date = "2019-07-17"
title = "Synology Nas: Installera Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-gitlab-on-synology/index.sv.md"
+++
Här visar jag hur jag installerade Gitlab och en Gitlab runner på min Synology NAS. Först måste GitLab-programmet installeras som ett Synology-paket. Sök efter "Gitlab" i "Package Centre" och klicka på "Install".   
{{< gallery match="images/1/*.*" >}}
Tjänsten lyssnar på port "30000" för mig. När allt har fungerat kallar jag mitt Gitlab med http://SynologyHostName:30000 och ser den här bilden:
{{< gallery match="images/2/*.*" >}}
När jag loggar in för första gången blir jag ombedd att ange det framtida lösenordet "admin". Det var det! Nu kan jag organisera projekt. Nu kan en Gitlab runner installeras.  
{{< gallery match="images/3/*.*" >}}
