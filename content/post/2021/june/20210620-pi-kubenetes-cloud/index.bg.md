+++
date = "2021-06-20"
title = "Страхотни неща с контейнери: Kubenetes клъстер и NFS съхранение"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.bg.md"
+++
Днес инсталирам нов клъстер на Kubenetes и имам много работа!
{{< gallery match="images/1/*.jpg" >}}
Поръчах тези компоненти за него:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x вентилатор, двоен: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x захранващи блокове: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x монтаж на стелаж: https://amzn.to/3H8vOg7
- 1x комплект от 600 броя свещи Dupont: https://amzn.to/3kcfYqQ
- 1x зелен светодиод с последователен резистор: https://amzn.to/3EQgXVp
- 1x син светодиод с последователен резистор: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Заглушително парче Черно: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x цокъл за лампа: https://amzn.to/3H0UZkG
## Хайде!

{{< youtube ulzMoX-fpvc >}}
Създадох свой собствен образ за инсталацията, базиран на инсталацията на Raspian Lite. Моят потребителски/публичен ключ вече е съхранен в това изображение, а файлът "/boot/config.txt" е адаптиран за моите светодиоди.
```
# meine Server brauchen kein HDMI, WLAN und Bluetooth
dtoverlay=disable-bt
dtoverlay=disable-wifi
disable_splash=1
hdmi_blanking=1
hdmi_ignore_hotplug=1
hdmi_ignore_composite=1
 
 
# Status-LEDs an GPIO weiterleiten
dtoverlay=act-led,gpio=21
dtparam=act_led_trigger=cpu0

```

## Сървър 1 - Монтиране на диск
Първо, инсталирам услугата NFS на "Сървър 1". Това хранилище може да се използва по-късно за моя контейнерен клъстер. Свързах USB твърдия диск към "Сървър 1" и го форматирах EXT4 с помощта на тези инструкции: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
След това създадох точка за монтиране за USB диска:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Въведох новата файлова система във файла "/etc/fstab" по следния начин:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Настройката може да се провери с "sudo mount -a". Сега USB дискът трябва да бъде монтиран в "/media/usb-disk".
##  Инсталиране на NFS
Този пакет е необходим за NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>В допълнение, на USB диска беше създадена нова папка
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Тогава трябва да се редактира файлът "/etc/exports". Там се въвеждат пътят, идентификаторът на потребителя и идентификаторът на групата:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Настройката може да бъде приета по следния начин.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Как мога да монтирам NFS?
Мога да монтирам тома по следния начин:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Или въведете за постоянно във файла "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
И тук мога да използвам "sudo mount -a".
## Инсталиране на Kubernetes
Следните команди трябва да се изпълнят на сървър 1, сървър 2 и сървър 3. Първо инсталираме Docker и добавяме потребителя "PI" към групата Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>След това настройката за размера на подмяната се нулира на всички сървъри. Това означава, че редактирам файла "/etc/dphys-swapfile" и задавам атрибута "CONF_SWAPSIZE" на "0".
{{< gallery match="images/4/*.png" >}}
>В допълнение трябва да се коригират настройките на "Control-Group" във файла "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Вижте:
{{< gallery match="images/5/*.png" >}}
>След това всички Raspberry трябва да се рестартират веднъж и да са готови за инсталацията на Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>След рестартирането инсталирам тези пакети на сървър 1, сървър 2 и сървър 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Само сървър 1
Сега главният модул на Kubenetes може да бъде инициализиран.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
След успешното инициализиране приемам настройките. Спомням си показаната команда "kubeadm join" за свързване на работните възли.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Сега, за съжаление, трябва да се направи нещо за мрежата.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Командата "kubectl get nodes" вече трябва да показва "Master" в състояние "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Добавяне на възли
Сега ни е необходима командата "kubeadm join" от инициализацията на Kubenetes. Въвеждам тази команда на "Сървър 2" и "Сървър 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Ако сега въведа командата "kubectl get nodes" от "Server 1" отново, тези възли вероятно ще се покажат в състояние "Not Ready". И тук се появява проблемът с мрежата, с който се сблъсква и капитанът. Изпълнявам отново командата отпреди, но този път добавям "f" за force.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>След това виждам всички възли готови за използване.
{{< gallery match="images/6/*.png" >}}

## Малка тестова демонстрация (Сървър 1/Kubenetes-Master)
Написах си малък тест за внедряване и проверих функциите. Създавам файл "nginx.yml" със следното съдържание:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
 selector:
   matchLabels:
     run: my-nginx
 replicas: 2
 template:
   metadata:
     labels:
       run: my-nginx
   spec:
     containers:
     - name: my-nginx
       image: nginx
       ports:
       - containerPort: 80

```
Сега започвам деплантацията:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Великолепно!
{{< gallery match="images/7/*.png" >}}
Създавам услуга и мога да извикам контейнера си.
{{< gallery match="images/8/*.png" >}}
Веднъж увеличих мащаба до 20 "реплики":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Вижте:
{{< gallery match="images/9/*.png" >}}

## Почистване на тестовата база
За да приключа, изтривам отново депото и услугата.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Вижте:
{{< gallery match="images/10/*.png" >}}
