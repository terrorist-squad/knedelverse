+++
date = "2020-02-16"
title = "Seminário Gitlab: Como posso implantar uma cópia estática do WordPress através do gasoduto Gitllab?"
difficulty = "level-2"
tags = ["cms", "git", "gitlab", "pipeline", "serverless", "wordpress"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-wordpress-pipeline/index.pt.md"
+++
Os sites estáticos carregam mais rápido e oferecem menos superfície de ataque. Eu mostro-lhe como converter uma página CMS através do Gitlab Pipline. Primeiro, eu crio uma fase de construção que gera uma cópia estática via wget.
```
uild:
  stage: build
  when: always
  only:
    - master 
  script:
    - mkdir static
    - rm -r .git
    - wget -k -K  -E -r -l 10 -p -N -F --restrict-file-names=windows -nH http://wordpress-adresse/ -P static >> /dev/null 2>&1 || true
    - find . -type f -exec sed -i 's#http://wordpress-adresse/#\//m#g' {} + >> /dev/null 2>&1
  artifacts:
    paths:
        - static/     
    expire_in: 24 week

```
O resultado ou artefato estático é arquivado por 24 semanas e pode ser implantado a qualquer momento através do gasoduto.
{{< gallery match="images/1/*.png" >}}
Na próxima etapa, o resultado pode ser implantado:
```
live:
  before_script:
    - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
  stage: deploy
  when: always
  only:
    - master  
  script:
    - rsync -avuz -e 'ssh -p {-P  Port wenn nötig} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' static/*  user@www.domain.com:/path/to/www.domain.de/public/

```
Feito! Encerrado mais uma vez todo o gasoduto (.gitlab_ci.yml)
```
stages:
  - build
  - deploy


build:
  stage: build
  when: always
  only:
    - master 
  script:
    - mkdir static
    - rm -r .git
    - wget -k -K  -E -r -l 10 -p -N -F --restrict-file-names=windows -nH http://wordpress-adresse/ -P static >> /dev/null 2>&1 || true
    - find . -type f -exec sed -i 's#http://wordpress-adresse/#\//m#g' {} + >> /dev/null 2>&1
  artifacts:
    paths:
        - static/     
    expire_in: 24 week
    
    
live:
  before_script:
    - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  stage: deploy
  when: always
  only:
    - master  
  script:
    - rsync -avuz -e 'ssh -p {-P  Port wenn nötig} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' static/*  user@www.domain.com:/path/to/www.domain.de/public/


```