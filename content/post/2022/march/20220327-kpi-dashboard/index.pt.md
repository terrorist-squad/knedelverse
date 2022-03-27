+++
date = "2022-03-21"
title = "Grandes coisas com contentores: Painel de instrumentos KPI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.pt.md"
+++
Especialmente na era Corona, com o trabalho descentralizado, a informação actualizada é muito procurada em todos os locais. Eu próprio já criei inúmeros sistemas de informação e gostaria de apresentar um grande software chamado Smashing.Speaker: https://smashing.github.io/Das O projecto Smashing foi originalmente desenvolvido sob o nome de Dashing pela empresa Shopify para a apresentação de números de negócios. Mas é claro que não se pode exibir apenas números de negócios. Desenvolvedores de todo o mundo desenvolveram Smashing tiles, os chamados widgets, para Gitlab, Jenkins, Bamboo, Jira, etc., veja:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch como você trabalha com isso?
## Passo 1: Criar imagem base
Primeiro, eu crio uma imagem simples do Docker que já inclui Ruby e Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Este é o primeiro conteúdo que escrevo no arquivo Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Então eu crio a imagem do Docker com este comando:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Isto é o que parece para mim:
{{< gallery match="images/1/*.png" >}}

## Passo 2: Criar Painel de Controle
Agora eu posso criar um novo painel com o seguinte comando:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Depois disso, a pasta "dashboard" no projeto Dashing deve se parecer com esta:
{{< gallery match="images/2/*.png" >}}
Muito bem! Agora tenho de actualizar novamente o Dockerfile. O novo conteúdo é este:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 
COPY dashboard/ /code/
 
RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
gem install bundler && \
apt-get clean
 
RUN cd /code/ && \
bundle
 
RUN chown -R www-data:www-data  /code/

USER www-data
WORKDIR /code/

EXPOSE 3030

CMD ["/usr/local/bin/bundle", "exec", "puma", "config.ru"]

```
Além disso, o arquivo Gemfile na pasta "dashboard" também deve ser adaptado:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Eu repito o comando de construção:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Agora eu posso iniciar meu novo painel pela primeira vez e acessá-lo em http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
E é este o aspecto:
{{< gallery match="images/3/*.png" >}}
