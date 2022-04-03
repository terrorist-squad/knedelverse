+++
date = "2021-06-25"
title = "Contrôler les PI à distance avec Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.fr.md"
+++
Après avoir créé un cluster Kubernetes dans le tutoriel [Du grand avec les conteneurs : cluster Kubenetes et stockage NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Du grand avec les conteneurs : cluster Kubenetes et stockage NFS"), je souhaite maintenant pouvoir accéder à ces ordinateurs via Ansible.
{{< gallery match="images/1/*.jpg" >}}
Pour cela, une nouvelle clé est nécessaire :
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Ajout de la nouvelle clé publique dans le fichier "/home/pi/.ssh/authorized_keys" de tous les serveurs (serveur 1, serveur 2 et serveur 3).En outre, ce paquet doit être installé pour Ansible :
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Ensuite, il faut ajouter les Raspberrys dans le fichier "/etc/ansible/hosts" :
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
La configuration peut maintenant être vérifiée comme suit :
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Voir
{{< gallery match="images/2/*.png" >}}
On peut maintenant exécuter des playbooks ou des commandes, par exemple redémarrer tous les serveurs :
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

