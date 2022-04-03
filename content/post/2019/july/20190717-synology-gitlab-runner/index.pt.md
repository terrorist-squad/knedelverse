+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Corredor em Docker Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.pt.md"
+++
Como eu instalo um runner Gitlab como um Docker no meu Synology NAS?
## Passo 1: Procura da imagem do Docker
Clico na guia "Registration" na janela do Synology Docker e procuro por Gitlab. Eu seleciono a imagem Docker "gitlab/gitlab-runner" e depois seleciono a etiqueta "bleeding".
{{< gallery match="images/1/*.png" >}}

## Passo 2: Colocar a imagem em funcionamento:

##  Problema dos anfitriões
A minha sinologia-gitlab-instrelação identifica-se sempre apenas pelo nome da pessoa. Como eu peguei o pacote original do Synology Gitlab no centro de pacotes, este comportamento não pode ser alterado posteriormente.  Como alternativa, posso incluir o meu próprio ficheiro de anfitriões. Aqui você pode ver que o nome do host "peter" pertence ao endereço IP Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Este arquivo é simplesmente armazenado no Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Passo 3: Preparar o GitLab Runner
Eu clico na minha imagem de corredor:
{{< gallery match="images/3/*.png" >}}
Ativei a configuração "Habilitar reinício automático":
{{< gallery match="images/4/*.png" >}}
Depois clico em "Definições avançadas" e selecciono o separador "Volume":
{{< gallery match="images/5/*.png" >}}
Clico em Adicionar Ficheiro e incluo o meu ficheiro anfitrião através do caminho "/etc/hosts". Este passo só é necessário se os nomes das hostes não puderem ser resolvidos.
{{< gallery match="images/6/*.png" >}}
Eu aceito as configurações e clique em next.
{{< gallery match="images/7/*.png" >}}
Agora encontro a imagem rubricada em Container:
{{< gallery match="images/8/*.png" >}}
Eu seleciono o recipiente (gitlab-gitlab-runner2 para mim) e clico em "Detalhes". Depois clico no separador "Terminal" e crio uma nova sessão de bash. Aqui eu digito o comando "gitlab-runner register". Para o registro, preciso de informações que posso encontrar na minha instalação do GitLab em http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Se precisar de mais pacotes, pode instalá-los através de "apt-get update" e depois "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Depois disso, posso incluir o corredor nos meus projectos e usá-lo:
{{< gallery match="images/11/*.png" >}}
