+++
date = "2021-04-25T09:28:11+01:00"
title = "História curta: Actualização automática de contentores com a Torre de Vigilância"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.pt.md"
+++
Se você executar os containers Docker na sua estação de disco, você naturalmente quer que eles estejam sempre atualizados. Torre de Vigilância actualiza automaticamente imagens e recipientes. Desta forma, você pode desfrutar das últimas características e da segurança de dados mais atualizada. Hoje vou mostrar-lhe como instalar uma Torre de Vigilância na estação de disco Synology.
## Passo 1: Preparar a Sinologia
Primeiro, o login do SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo esta consola aberta para mais tarde.
## Passo 2: Instalar a Torre de Vigilância
Eu uso a consola para isto:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Depois disso, a Torre de Vigilância corre sempre em segundo plano.
{{< gallery match="images/3/*.png" >}}

