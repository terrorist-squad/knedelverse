+++
date = "2020-02-16"
title = "Seminár Gitlab: Ako môžem nasadiť statickú kópiu WordPress prostredníctvom potrubia Gitllab?"
difficulty = "level-2"
tags = ["cms", "git", "gitlab", "pipeline", "serverless", "wordpress"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-wordpress-pipeline/index.sk.md"
+++
Statické webové stránky sa načítavajú rýchlejšie a ponúkajú menší priestor na útoky. Ukážem vám, ako konvertovať stránku CMS prostredníctvom Pipline Gitlab. Najprv vytvorím fázu zostavenia, ktorá vygeneruje statickú kópiu pomocou nástroja wget.
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
Výsledok alebo statický artefakt sa archivuje 24 týždňov a môže sa kedykoľvek nasadiť prostredníctvom potrubia.
{{< gallery match="images/1/*.png" >}}
V ďalšom kroku je možné výsledok nasadiť:
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
Hotovo! Opäť prikladáme celý pipeline (.gitlab_ci.yml)
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