+++
date = "2020-02-16"
title = "Gitlab szeminárium: Hogyan tudok telepíteni egy statikus WordPress másolatot a Gitllab pipeline-on keresztül?"
difficulty = "level-2"
tags = ["cms", "git", "gitlab", "pipeline", "serverless", "wordpress"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-wordpress-pipeline/index.hu.md"
+++
A statikus weboldalak gyorsabban töltődnek be, és kisebb támadási felületet kínálnak. Megmutatom, hogyan lehet egy CMS oldalt a Gitlab Pipline segítségével átalakítani. Először létrehozok egy build stage-et, amely a wget segítségével létrehoz egy statikus másolatot.
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
Az eredményt vagy statikus artefaktumot 24 hétig archiváljuk, és a csővezetéken keresztül bármikor bevethető.
{{< gallery match="images/1/*.png" >}}
A következő lépésben az eredményt be lehet vetni:
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
Kész! Ismét mellékelve a teljes csővezeték (.gitlab_ci.yml)
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