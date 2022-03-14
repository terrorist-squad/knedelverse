+++
date = "2020-02-16"
title = "Σεμινάριο Gitlab: Πώς μπορώ να αναπτύξω ένα στατικό αντίγραφο του WordPress μέσω του αγωγού Gitllab;"
difficulty = "level-2"
tags = ["cms", "git", "gitlab", "pipeline", "serverless", "wordpress"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200216-wordpress-pipeline/index.el.md"
+++
Οι στατικοί ιστότοποι φορτώνουν ταχύτερα και προσφέρουν μικρότερη επιφάνεια επίθεσης. Σας δείχνω πώς να μετατρέψετε μια σελίδα CMS μέσω του Gitlab Pipline. Πρώτα, δημιουργώ ένα στάδιο κατασκευής που δημιουργεί ένα στατικό αντίγραφο μέσω του wget.
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
Το αποτέλεσμα ή το στατικό τεχνούργημα αρχειοθετείται για 24 εβδομάδες και μπορεί να αναπτυχθεί ανά πάσα στιγμή μέσω του αγωγού.
{{< gallery match="images/1/*.png" >}}
Στο επόμενο βήμα, το αποτέλεσμα μπορεί να αναπτυχθεί:
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
Έγινε! Επισυνάπτεται για άλλη μια φορά ολόκληρος ο αγωγός (.gitlab_ci.yml)
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