+++
date = "2019-07-17"
title = "Synology Nas: Installer Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.da.md"
+++
Her viser jeg, hvordan jeg installerede Gitlab og en Gitlab runner på min Synology NAS. Først skal GitLab-programmet installeres som en Synology-pakke. Søg efter "Gitlab" i "Package Centre", og klik på "Install".   
{{< gallery match="images/1/*.*" >}}
Tjenesten lytter til port "30000" for mig. Når alt har virket, kalder jeg mit Gitlab med http://SynologyHostName:30000 og ser dette billede:
{{< gallery match="images/2/*.*" >}}
Når jeg logger ind første gang, bliver jeg bedt om den fremtidige "admin"-adgangskode. Det var det! Nu kan jeg organisere projekter. Nu kan der installeres en Gitlab runner.  
{{< gallery match="images/3/*.*" >}}
