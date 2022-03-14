+++
date = "2019-07-17"
title = "PIFM : 104.6 dans le monde entier sur la radio FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.fr.md"
+++
Si vous êtes un fan de 104.6 RTL et que vous ne voulez pas passer une journée sans écouter la hitradio de Berlin, vous êtes au bon endroit. Il faut un ordinateur monocarte appelé Raspberry et un câble sur le port GPIO 4 en guise d'antenne.
## Les paquets suivants sont nécessaires

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Je crée un dossier de téléchargement et je télécharge le script PIFM :
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## Script pifm
Je crée un nouveau fichier "$vim /home/pi/radio-streamer.sh" avec le contenu suivant :
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Le script a besoin des droits suivants :
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Crontjob possible
L'ordinateur est redémarré chaque nuit entre 4 et 5 heures. De plus, le radion se reconnecte toutes les heures.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```