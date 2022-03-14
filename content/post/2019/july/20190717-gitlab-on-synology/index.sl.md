+++
date = "2019-07-17"
title = "Synology Nas: Namestite Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-gitlab-on-synology/index.sl.md"
+++
Tukaj prikazujem, kako sem namestil program Gitlab in izvajalca Gitlab v svoj strežnik Synology NAS. Najprej je treba aplikacijo GitLab namestiti kot paket Synology. V Centru paketov poiščite Gitlab in kliknite "Namesti".   
{{< gallery match="images/1/*.*" >}}
Storitev posluša vrata "30000" za mene. Ko je vse delovalo, prikličem svoj Gitlab s http://SynologyHostName:30000 in vidim to sliko:
{{< gallery match="images/2/*.*" >}}
Ko se prvič prijavim, me vpraša za prihodnje geslo "admin". To je bilo to! Zdaj lahko organiziram projekte. Zdaj lahko namestite izvajalca Gitlab.  
{{< gallery match="images/3/*.*" >}}
