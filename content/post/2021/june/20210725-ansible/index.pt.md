+++
date = "2021-06-25"
title = "Controle remoto de PIs com Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.pt.md"
+++
Depois de criar um cluster Kubernetes no tutorial [Grandes coisas com contentores: aglomerado Kubenetes e armazenamento NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandes coisas com contentores: aglomerado Kubenetes e armazenamento NFS"), gostaria agora de ser capaz de abordar estes computadores via Ansible.
{{< gallery match="images/1/*.jpg" >}}
Uma nova chave é necessária para isso:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Adicionada a nova chave pública ao ficheiro "/home/pi/.ssh/authorised_keys" de todos os servidores (Servidor 1, Servidor 2 e Servidor 3), este pacote deve também ser instalado para o Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Depois disso, os Raspberrys devem ser inseridos no arquivo "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Agora a configuração pode ser verificada da seguinte forma:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Veja:
{{< gallery match="images/2/*.png" >}}
Agora você pode executar playbooks ou comandos, por exemplo, reiniciar todos os servidores:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

