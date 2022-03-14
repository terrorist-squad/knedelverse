+++
date = "2021-06-25"
title = "Controllare i PI da remoto con Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.it.md"
+++
Dopo aver creato un cluster Kubernetes nel tutorial [Grandi cose con i container: cluster Kubenetes e storage NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandi cose con i container: cluster Kubenetes e storage NFS"), vorrei ora essere in grado di indirizzare questi computer tramite Ansible.
{{< gallery match="images/1/*.jpg" >}}
Per questo è necessaria una nuova chiave:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Aggiunta la nuova chiave pubblica al file "/home/pi/.ssh/authorised_keys" di tutti i server (Server 1, Server 2 e Server 3).Inoltre, questo pacchetto deve essere installato per Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Dopo di che, i Raspberry devono essere inseriti nel file "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Ora la configurazione può essere controllata come segue:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Vedere:
{{< gallery match="images/2/*.png" >}}
Ora puoi eseguire playbook o comandi, per esempio riavviare tutti i server:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
