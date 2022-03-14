+++
date = "2020-02-16"
title = "Seminář Gitlabu: Jak mohu nasadit statickou kopii WordPressu prostřednictvím potrubí Gitlabu?"
difficulty = "level-2"
tags = ["cms", "git", "gitlab", "pipeline", "serverless", "wordpress"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-wordpress-pipeline/index.cs.md"
+++
Statické webové stránky se načítají rychleji a nabízejí menší prostor pro útoky. Ukážu vám, jak převést stránku CMS přes Gitlab Pipline. Nejprve vytvořím fázi sestavení, která vygeneruje statickou kopii pomocí nástroje wget.
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
Výsledek nebo statický artefakt je archivován po dobu 24 týdnů a může být kdykoli nasazen prostřednictvím potrubí.
{{< gallery match="images/1/*.png" >}}
V dalším kroku lze výsledek nasadit:
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
Hotovo! Opět přikládáme celý soubor (.gitlab_ci.yml)
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