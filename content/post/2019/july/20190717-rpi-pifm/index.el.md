+++
date = "2019-07-17"
title = "PIFM: 104,6 παγκοσμίως στο ραδιόφωνο FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.el.md"
+++
Αν είστε οπαδός του 104,6 RTL και δεν θέλετε να περάσετε ούτε μια μέρα χωρίς το ραδιόφωνο του Βερολίνου, τότε είστε στο σωστό μέρος. Χρειάζεστε έναν υπολογιστή μιας πλακέτας που ονομάζεται Raspberry και ένα καλώδιο στη θύρα GPIO 4 ως κεραία.
## Απαιτούνται τα ακόλουθα πακέτα

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Δημιουργώ έναν φάκελο λήψης και κατεβάζω το σενάριο PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## σενάριο pifm
Δημιουργώ ένα νέο αρχείο "$vim /home/pi/radio-streamer.sh" με το ακόλουθο περιεχόμενο:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Το σενάριο χρειάζεται τα ακόλουθα δικαιώματα:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Πιθανή crontjob
Ο υπολογιστής επανεκκινείται κάθε βράδυ μεταξύ 4 και 5 η ώρα. Επιπλέον, το Radion επανασυνδέεται κάθε μία ώρα.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```