+++
date = "2021-06-25"
title = "Fjernstyring af PIs med Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.da.md"
+++
Efter at have oprettet en Kubernetes-klynge i [Store ting med containere: Kubenetes klynge og NFS-lagring]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Store ting med containere: Kubenetes klynge og NFS-lagring")-tutorialet vil jeg nu gerne kunne adressere disse computere via Ansible.
{{< gallery match="images/1/*.jpg" >}}
Der er brug for en ny nøgle til dette:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Tilføjede den nye offentlige nøgle til filen "/home/pi/.ssh/authorised_keys" på alle servere (Server 1, Server 2 og Server 3).Denne pakke skal også være installeret for Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Herefter skal Raspberrys angives i filen "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Nu kan konfigurationen kontrolleres på følgende måde:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Se:
{{< gallery match="images/2/*.png" >}}
Nu kan du udføre playbooks eller kommandoer, f.eks. genstarte alle servere:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

