+++
date = "2022-03-21"
title = "Μεγάλα πράγματα με δοχεία: KPI Dashboard"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "dashboard", "kpi", "kpi-dashboard", "kennzahlen", "wallboard"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220327-kpi-dashboard/index.el.md"
+++
Ειδικά στην εποχή της Corona, με την αποκεντρωμένη εργασία, η επικαιροποιημένη πληροφόρηση έχει μεγάλη ζήτηση σε όλες τις τοποθεσίες. Εγώ ο ίδιος έχω ήδη δημιουργήσει αμέτρητα πληροφοριακά συστήματα και θα ήθελα να σας παρουσιάσω ένα σπουδαίο λογισμικό που ονομάζεται Smashing.Speaker: https://smashing.github.io/Das Το έργο Smashing αναπτύχθηκε αρχικά με την ονομασία Dashing από την εταιρεία Shopify για την παρουσίαση επιχειρηματικών στοιχείων. Αλλά φυσικά δεν μπορείτε να εμφανίζετε μόνο επιχειρηματικά στοιχεία. Προγραμματιστές από όλο τον κόσμο έχουν αναπτύξει πλακίδια Smashing, τα λεγόμενα widgets, για τα Gitlab, Jenkins, Bamboo, Jira κ.λπ., βλ.:https://github.com/Smashing/smashing/wiki/Additional-WidgetsDoch πώς δουλεύετε με αυτά;
## Βήμα 1: Δημιουργία βασικής εικόνας
Αρχικά, δημιουργώ μια απλή εικόνα Docker που περιλαμβάνει ήδη το Ruby και το Dashing.
{{< terminal >}}
mkdir dashing-project
cd dashing-project
mkdir dashboard
vim Dockerfile

{{</ terminal >}}
Αυτό είναι το πρώτο περιεχόμενο που γράφω στο αρχείο Dockerfile:
```
From ubuntu:latest
 
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY dashboard/ /code/

RUN apt-get update && apt-get install -y ruby wget unzip ruby-dev build-essential tzdata nodejs && \
gem install smashing && \
apt-get clean

```
Στη συνέχεια δημιουργώ την εικόνα Docker με αυτή την εντολή:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Έτσι φαίνεται για μένα:
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Δημιουργία ταμπλό
Τώρα μπορώ να δημιουργήσω ένα νέο ταμπλό με την ακόλουθη εντολή:
{{< terminal >}}
docker run -it -v /path/to/my/dashing-project:/code my-dashboard:latest smashing new dashboard

{{</ terminal >}}
Μετά από αυτό, ο φάκελος "dashboard" στο έργο Dashing θα πρέπει να μοιάζει με αυτό:
{{< gallery match="images/2/*.png" >}}
Πολύ καλά! Τώρα πρέπει να ενημερώσω ξανά το αρχείο Docker. Το νέο περιεχόμενο είναι το εξής:
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
Επιπλέον, το αρχείο Gemfile στο φάκελο "dashboard" πρέπει επίσης να προσαρμοστεί:
```
source 'https://rubygems.org'

gem 'smashing'
gem 'puma'

```
Επαναλαμβάνω την εντολή κατασκευής:
{{< terminal >}}
docker build -t my-dashboard:latest .

{{</ terminal >}}
Τώρα μπορώ να ξεκινήσω το νέο μου ταμπλό για πρώτη φορά και να έχω πρόσβαση σε αυτό στη διεύθυνση http://localhost:9292.
{{< terminal >}}
docker run -it -p 9292:9292 my-dashboard:latest

{{</ terminal >}}
Και κάπως έτσι φαίνεται:
{{< gallery match="images/3/*.png" >}}
Αυτή είναι η βάση για ένα καλό σύστημα πληροφοριών. Μπορείτε να προσαρμόσετε όλα τα χρώματα, τα σενάρια και τα widgets.
