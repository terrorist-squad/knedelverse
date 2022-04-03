+++
date = "2019-07-17"
title = "Synology-Nas : Gitlab - Runner dans le conteneur Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.fr.md"
+++
Comment installer un runner Gitlab en tant que conteneur Docker sur mon Synology-Nas ?
## Étape 1 : Trouver une image Docker
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche Gitlab. Je choisis l'image docker "gitlab/gitlab-runner" et je sélectionne ensuite le tag "bleeding".
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Mettre l'image en service :

##  Problème des hôtes
Ma synology-gitlab-insterlation s'identifie toujours par le nom d'hôte uniquement. Comme j'ai pris le paquet Synology-Gitlab original dans le centre de paquets, ce comportement ne peut pas être modifié après coup.  Comme solution de contournement, je peux intégrer mon propre fichier Hosts. Ici, on peut voir que le nom d'hôte "peter" appartient à l'adresse IP du Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Ce fichier est simplement placé sur le Synology-Nas.
{{< gallery match="images/2/*.png" >}}

## Étape 3 : configurer le GitLab Runner
Je clique sur mon image de Runner :
{{< gallery match="images/3/*.png" >}}
J'active le paramètre "Activer le redémarrage automatique" :
{{< gallery match="images/4/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et je sélectionne l'onglet "Volume" :
{{< gallery match="images/5/*.png" >}}
Je clique sur Ajouter un fichier et j'intègre mon fichier hosts via le chemin "/etc/hosts". Cette étape n'est nécessaire que si le nom d'hôte ne peut pas être résolu.
{{< gallery match="images/6/*.png" >}}
J'accepte les paramètres et je clique sur continuer
{{< gallery match="images/7/*.png" >}}
Je trouve maintenant l'image initialisée sous Container :
{{< gallery match="images/8/*.png" >}}
Je choisis le conteneur (gitlab-gitlab-runner2 pour moi) et je clique sur "Détails". Ensuite, je clique sur l'onglet "Terminal" et je crée une nouvelle session Bash. Ici, je saisis la commande "gitlab-runner register". Pour l'enregistrement, j'ai besoin d'informations que je trouve dans mon installation GitLab à l'adresse suivante : http://gitlab-adresse:port/admin/runners   
{{< gallery match="images/9/*.png" >}}
Si vous avez besoin d'autres paquets, vous pouvez les installer via "apt-get update" et ensuite "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Ensuite, je peux enregistrer et utiliser le runner dans mes projets :
{{< gallery match="images/11/*.png" >}}
