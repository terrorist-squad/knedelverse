+++
date = "2021-04-18"
title = "Coisas ótimas com recipientes: Executando Docspell DMS no Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-Docspell/index.pt.md"
+++
Docspell é um sistema de gerenciamento de documentos para o Synology DiskStation. Através do Docspell, os documentos podem ser indexados, pesquisados e encontrados muito mais rapidamente. Hoje eu mostro como instalar um serviço Docspell na estação de disco Synology.
## Passo 1: Preparar a Sinologia
Primeiro, o login SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo este console aberto para mais tarde.
## Passo 2: Criar pasta Docspel
Eu crio um novo diretório chamado "docspell" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Agora o seguinte arquivo deve ser baixado e descompactado no diretório: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Eu uso a consola para isto:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Depois edito o ficheiro "docker/docker-compose.yml" e introduzo os meus endereços Synology em "consumedir" e "db":
{{< gallery match="images/4/*.png" >}}
Depois disso, posso iniciar o arquivo Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Após alguns minutos, posso chamar o meu servidor Docspell com o IP da estação de disco e a porta atribuída/7878.
{{< gallery match="images/5/*.png" >}}
