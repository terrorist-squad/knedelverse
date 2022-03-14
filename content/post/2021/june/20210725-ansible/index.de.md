+++
date = "2021-06-25"
title = "PIs fernsteuern mit Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.de.md"
+++


Nachdem ich im  [Großartiges mit Containern: Kubenetes-Cluster und NFS-Speicher]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Großartiges mit Containern: Kubenetes-Cluster und NFS-Speicher")-Tutorial ein Kubernetes - Cluster erzeugt habe, möchte ich diese Rechner nun auch über Ansible ansprechen können.
{{< gallery match="images/1/*.jpg" >}}


Dafür wird ein neuer Schlüssel benötigt:
{{< terminal >}}
ssh-keygen -b 4096
{{</ terminal >}}

Der neue Public-Schlüssel in die "/home/pi/.ssh/authorized_keys"-Datei aller Server hinzugefügt (Server 1, Server 2 und Server 3).

Außerdem muss dieses Paket für Ansible installiert werden:
{{< terminal >}}
sudo apt-get install -y ansible
{{</ terminal >}}

Danach müssen die Raspberrys in die "/etc/ansible/hosts"-Datei eingetragen werden:
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 
```

Nun kann der die Konfiguration wie folgt geprüft werden:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'
{{</ terminal >}}

Siehe:
{{< gallery match="images/2/*.png" >}}

Jetzt kann man Playbooks oder Befehle ausführen, zum Beispiel alle Server rebooten:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'
{{</ terminal >}}

