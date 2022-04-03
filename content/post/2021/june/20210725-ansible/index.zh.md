+++
date = "2021-06-25"
title = "用Ansible远程控制PIs"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210725-ansible/index.zh.md"
+++
在[容器的伟大之处：Kubenetes集群和NFS存储]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "容器的伟大之处：Kubenetes集群和NFS存储")教程中创建了一个Kubernetes集群后，我现在希望能够通过Ansible解决这些计算机。
{{< gallery match="images/1/*.jpg" >}}
为此需要一个新的钥匙。
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
在所有服务器（服务器1、服务器2和服务器3）的"/home/pi/.ssh/authorised_keys "文件中添加了新的公钥。此外，Ansible必须安装这个包。
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
之后，必须在"/etc/ansible/hosts "文件中输入Raspberrys。
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
现在可以按以下方式检查配置。
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
见。
{{< gallery match="images/2/*.png" >}}
现在你可以执行playbooks或命令，例如重新启动所有服务器。
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}

