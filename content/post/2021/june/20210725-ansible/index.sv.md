+++
date = "2021-06-25"
title = "Fjärrstyrning av PIs med Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.sv.md"
+++
Efter att ha skapat ett Kubernetes-kluster i [Stora saker med containrar: Kubenetes kluster och NFS-lagring]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Stora saker med containrar: Kubenetes kluster och NFS-lagring")-handledningen vill jag nu kunna hantera dessa datorer via Ansible.
{{< gallery match="images/1/*.jpg" >}}
För detta behövs en ny nyckel:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Lägg till den nya offentliga nyckeln i filen "/home/pi/.ssh/authorised_keys" på alla servrar (Server 1, Server 2 och Server 3).Det här paketet måste också installeras för Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
Därefter måste Raspberrys anges i filen "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Nu kan konfigurationen kontrolleras på följande sätt:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Se:
{{< gallery match="images/2/*.png" >}}
Nu kan du utföra spelböcker eller kommandon, till exempel starta om alla servrar:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
