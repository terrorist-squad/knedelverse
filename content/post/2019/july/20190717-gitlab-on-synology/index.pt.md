+++
date = "2019-07-17"
title = "Synology Nas: Instalar o Gitlab?"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.pt.md"
+++
Aqui eu mostro como instalei o Gitlab e um corredor Gitlab no meu NAS Synology. Primeiro, o aplicativo GitLab deve ser instalado como um pacote Synology. Procure por "Gitlab" no "Centro de Pacotes" e clique em "Instalar".   
{{< gallery match="images/1/*.*" >}}
O serviço ouve a porta "30000" para mim. Quando tudo tiver funcionado, ligo para o meu Gitlab com http://SynologyHostName:30000 e vejo esta foto:
{{< gallery match="images/2/*.*" >}}
Quando inicio a sessão pela primeira vez, é-me pedida a futura palavra-passe "admin". Foi isso! Agora eu posso organizar projectos. Agora um runner Gitlab pode ser instalado.  
{{< gallery match="images/3/*.*" >}}
