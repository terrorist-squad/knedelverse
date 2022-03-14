+++
date = "2021-06-25"
title = "Дистанционно управление на PI с Ansible"
difficulty = "level-2"
tags = ["ansible", "raspberry", "pi", "cloud", "homelab", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210725-ansible/index.bg.md"
+++
След като създадох клъстер Kubernetes в урока за [Страхотни неща с контейнери: Kubenetes клъстер и NFS съхранение]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Страхотни неща с контейнери: Kubenetes клъстер и NFS съхранение"), сега бих искал да мога да се обърна към тези компютри чрез Ansible.
{{< gallery match="images/1/*.jpg" >}}
За тази цел е необходим нов ключ:
{{< terminal >}}
ssh-keygen -b 4096

{{</ terminal >}}
Добавяне на новия публичен ключ във файла "/home/pi/.ssh/authorised_keys" на всички сървъри (Сървър 1, Сървър 2 и Сървър 3).Също така този пакет трябва да бъде инсталиран за Ansible:
{{< terminal >}}
sudo apt-get install -y ansible

{{</ terminal >}}
След това Raspberrys трябва да бъдат въведени във файла "/etc/ansible/hosts":
```
[raspi-kube.clust]
ip-server-1:ssh-port ansible_ssh_user=username 
ip-server-2:ssh-port ansible_ssh_user=username 
ip-server-3:ssh-port ansible_ssh_user=username 

```
Сега конфигурацията може да се провери по следния начин:
{{< terminal >}}
ansible all -m ping --ssh-common-args='-o StrictHostKeyChecking=no'

{{</ terminal >}}
Вижте:
{{< gallery match="images/2/*.png" >}}
Сега можете да изпълнявате книги за изпълнение или команди, например да рестартирате всички сървъри:
{{< terminal >}}
ansible raspi -m shell -a 'sudo /sbin/reboot'

{{</ terminal >}}
