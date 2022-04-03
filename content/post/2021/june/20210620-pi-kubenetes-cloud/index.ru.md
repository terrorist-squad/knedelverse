+++
date = "2021-06-20"
title = "Большие вещи с контейнерами: кластер Kubenetes и хранилище NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.ru.md"
+++
Сегодня я устанавливаю новый кластер Kubenetes, и мне предстоит многое сделать!
{{< gallery match="images/1/*.jpg" >}}
Я заказал для него эти компоненты:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x вентилятор, двойной: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x блоки питания: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 шт. комплект дюбелей Dupont: https://amzn.to/3kcfYqQ
- 1x зеленый светодиод с последовательным резистором: https://amzn.to/3EQgXVp
- 1x синий светодиод с последовательным резистором: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Заглушка черная: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x основание лампы: https://amzn.to/3H0UZkG
## Поехали!

{{< youtube ulzMoX-fpvc >}}
Я создал свой собственный образ для установки на основе установки Raspian Lite. Мой пользовательский/публичный ключ уже хранится в этом образе, а файл "/boot/config.txt" был адаптирован для моих светодиодов.
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

## Сервер 1 - Смонтировать диск
Сначала я устанавливаю службу NFS на "Сервер 1". Это хранилище может быть использовано позже для моего контейнерного кластера. Я подключил жесткий диск USB к "Серверу 1" и отформатировал его EXT4 с помощью этих инструкций: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/.
{{< gallery match="images/3/*.jpg" >}}
Затем я создал точку монтирования для USB-диска:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Я ввел новую файловую систему в файл "/etc/fstab" следующим образом:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Настройку можно проверить с помощью команды "sudo mount -a". Теперь USB-диск должен быть смонтирован в папку "/media/usb-disk".
##  Установите NFS
Этот пакет необходим для работы NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Кроме того, на USB-диске была создана новая папка
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Затем необходимо отредактировать файл "/etc/exports". Там вводится путь, идентификатор пользователя и идентификатор группы:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Сейчас настройку можно принять следующим образом.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Как я могу смонтировать NFS?
Я могу смонтировать том следующим образом:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Или введите постоянную информацию в файл "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Здесь я также могу использовать "sudo mount -a".
## Установите Kubernetes
Следующие команды должны быть выполнены на сервере 1, сервере 2 и сервере 3. Сначала мы установим Docker и добавим пользователя "PI" в группу Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>После этого параметр размера подкачки обнуляется на всех серверах. Это означает, что я редактирую файл "/etc/dphys-swapfile" и устанавливаю атрибут "CONF_SWAPSIZE" на "0".
{{< gallery match="images/4/*.png" >}}
>Кроме того, необходимо изменить настройки "Control-Group" в файле "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
См:
{{< gallery match="images/5/*.png" >}}
>Теперь все Raspberry должны перезагрузиться один раз и готовы к установке Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>После перезагрузки я устанавливаю эти пакеты на сервер 1, сервер 2 и сервер 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Только сервер 1
Теперь мастер Kubenetes может быть инициализирован.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
После успешной инициализации я принимаю настройки. Я помню отображаемую команду "kubeadm join" для соединения рабочих узлов.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Теперь, к сожалению, нужно что-то делать для сети.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Команда "kubectl get nodes" теперь должна показывать "Master" в состоянии "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Добавить узлы
Теперь нам нужна команда "kubeadm join" из инициализации Kubenetes. Я ввожу эту команду на "Сервере 2" и "Сервере 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Если теперь я снова введу команду "kubectl get nodes" с "Сервера 1", эти узлы, вероятно, будут отображаться в статусе "Не готов". Здесь также возникает проблема с сетью, которая была и у мастера. Я снова выполняю предыдущую команду, но на этот раз я добавляю "f" для силы.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>После этого я вижу все узлы, готовые к использованию.
{{< gallery match="images/6/*.png" >}}

## Небольшой тестовый деплоймент (сервер 1/Kubenetes-Master)
Я написал небольшое тестовое развертывание и проверил функции. Я создаю файл "nginx.yml" со следующим содержимым:
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
Теперь я начинаю увольнение:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Здорово!
{{< gallery match="images/7/*.png" >}}
Я создаю службу и могу вызвать свой контейнер.
{{< gallery match="images/8/*.png" >}}
Я масштабирую один раз до 20 "реплик":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>См:
{{< gallery match="images/9/*.png" >}}

## Очистить тестовый отдел
Чтобы навести порядок, я снова удаляю деплоймент и услугу.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>См:
{{< gallery match="images/10/*.png" >}}

