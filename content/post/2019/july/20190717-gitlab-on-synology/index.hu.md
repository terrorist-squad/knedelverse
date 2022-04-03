+++
date = "2019-07-17"
title = "Synology Nas: Gitlab telepítése?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.hu.md"
+++
Itt megmutatom, hogyan telepítettem a Gitlabot és egy Gitlab futót a Synology NAS-ra. Először a GitLab alkalmazást kell telepíteni Synology csomagként. Keresse meg a "Gitlab"-ot a "Csomagközpontban", és kattintson a "Telepítés" gombra.   
{{< gallery match="images/1/*.*" >}}
A szolgáltatás a "30000" portot figyeli számomra. Amikor minden működött, meghívom a Gitlabomat a http://SynologyHostName:30000 címmel, és ezt a képet látom:
{{< gallery match="images/2/*.*" >}}
Amikor először jelentkezem be, a jövőbeni "admin" jelszót kell megadnom. Ez volt az! Most már tudom szervezni a projekteket. Most már telepíthető egy Gitlab runner.  
{{< gallery match="images/3/*.*" >}}

