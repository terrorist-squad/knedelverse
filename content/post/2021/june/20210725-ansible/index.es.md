+++
date = "2021-06-25"
title = "Controlar las IPs de forma remota con Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.es.md"
+++
Después de crear un clúster de Kubernetes en el tutorial de [Grandes cosas con contenedores: clúster Kubenetes y almacenamiento NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandes cosas con contenedores: clúster Kubenetes y almacenamiento NFS"), ahora me gustaría ser capaz de dirigir estos equipos a través de Ansible.
{{< gallery match="images/1/*.jpg" >}}
Para ello se necesita una nueva llave:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Se ha añadido la nueva clave pública al archivo "/home/pi/.ssh/authorised_keys" de todos los servidores (Servidor 1, Servidor 2 y Servidor 3).Además, este paquete debe estar instalado para Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Después de eso, las Raspberrys deben ser introducidas en el archivo "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Ahora se puede comprobar la configuración de la siguiente manera:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Ver:
{{< gallery match="images/2/*.png" >}}
Ahora puedes ejecutar playbooks o comandos, por ejemplo reiniciar todos los servidores:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
