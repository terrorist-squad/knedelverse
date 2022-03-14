+++
date = "2021-05-30"
title = "Udemy Downloader no Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.pt.md"
+++
Neste tutorial você aprenderá como baixar os cursos "udemy" para uso offline.
## Passo 1: Preparar a pasta Udemy
Eu crio um novo diretório chamado "udemy" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instale a imagem do Ubuntu
Clico na guia "Registration" na janela do Synology Docker e procuro por "ubunutu". Selecciono a imagem do Docker "ubunutu" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Faço duplo clique na minha imagem do Ubuntu. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/3/*.png" >}}
Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta com este caminho de montagem "/download".
{{< gallery match="images/4/*.png" >}}
Agora o contentor pode ser iniciado.
{{< gallery match="images/5/*.png" >}}

## Passo 4: Instalar o Udemy Downloader
Clico em "Container" na janela do Synology Docker e faço duplo clique no meu "Udemy container". Depois clico no separador "Terminal" e introduzo os seguintes comandos.
{{< gallery match="images/6/*.png" >}}

##  Comandos:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Imagens de ecrã:
{{< gallery match="images/7/*.png" >}}

## Passo 4: Colocar o descarregador Udemy em funcionamento
Agora preciso de uma "ficha de acesso". Eu visito Udemy com meu navegador Firefox e abro o Firebug. Eu clico no separador "Armazenamento Web" e copio o "Token de acesso".
{{< gallery match="images/8/*.png" >}}
Eu crio um novo ficheiro no meu contentor:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Depois disso posso fazer o download dos cursos que já comprei:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Veja:
{{< gallery match="images/9/*.png" >}}
