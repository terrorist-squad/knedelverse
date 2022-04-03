+++
date = "2022-04-02"
title = "De grandes choses avec les conteneurs : installer Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.fr.md"
+++
Avec Jitsi, vous pouvez créer et utiliser une solution de vidéoconférence sécurisée. Aujourd'hui, je montre comment installer un service Jitsi sur un serveur, référence : https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Étape 1 : créer un dossier "jitsi".
Je crée un nouveau répertoire appelé "jitsi" pour l'installation.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Étape 2 : Configuration
Maintenant, je copie la configuration par défaut et je l'adapte.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Voir
{{< gallery match="images/1/*.png" >}}
Pour utiliser des mots de passe sûrs dans les options de sécurité du fichier .env, le script bash suivant doit être exécuté une fois.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Maintenant, je crée encore quelques dossiers pour Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Ensuite, le serveur Jitsi peut être démarré.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Ensuite, on peut utiliser le serveur Jitsi !
{{< gallery match="images/2/*.png" >}}

