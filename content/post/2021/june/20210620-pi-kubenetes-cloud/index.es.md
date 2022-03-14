+++
date = "2021-06-20"
title = "Grandes cosas con contenedores: clúster Kubenetes y almacenamiento NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.es.md"
+++
¡Hoy estoy instalando un nuevo cluster de Kubenetes y hay mucho que hacer!
{{< gallery match="images/1/*.jpg" >}}
He pedido estos componentes para ello:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x ventilador, doble: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x fuentes de alimentación: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Montaje en rack: https://amzn.to/3H8vOg7
- 1x Kit de enchufes Dupont de 600 piezas: https://amzn.to/3kcfYqQ
- 1 LED verde con resistencia en serie: https://amzn.to/3EQgXVp
- 1x LED azul con resistencia en serie: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Pieza ciega Negra: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1 base de lámpara: https://amzn.to/3H0UZkG
## ¡Vamos!

{{< youtube ulzMoX-fpvc >}}
He creado mi propia imagen para la instalación basada en la instalación de Raspian Lite. Mi clave de usuario/pública ya está almacenada en esta imagen y el archivo "/boot/config.txt" ha sido adaptado para mis LEDs.
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

## Servidor 1 - Montar disco
Primero, instalo un servicio NFS en el "Servidor 1". Este almacenamiento puede ser utilizado más tarde para mi cluster de contenedores. Conecté el disco duro USB al "Servidor 1" y lo formateé EXT4 con la ayuda de estas instrucciones: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Luego creé un punto de montaje para el disco USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
He introducido el nuevo sistema de archivos en el archivo "/etc/fstab" de la siguiente manera:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
La configuración se puede comprobar con "sudo mount -a". Ahora el disco USB debería estar montado en "/media/usb-disk".
##  Instalar NFS
Este paquete es necesario para NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Además, se creó una nueva carpeta en el disco USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Entonces hay que editar el archivo "/etc/exports". Allí se introducen la ruta, el ID de usuario y el ID de grupo:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Ahora la configuración puede adoptarse como sigue.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  ¿Cómo puedo montar el NFS?
Puedo montar el volumen de la siguiente manera:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
O introduzca permanentemente en el archivo "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Aquí también puedo usar "sudo mount -a".
## Instalar Kubernetes
Los siguientes comandos deben ejecutarse en el servidor 1, el servidor 2 y el servidor 3. Primero instalamos Docker y añadimos el usuario "PI" al grupo Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Después de eso, la configuración del tamaño de intercambio se pone a cero en todos los servidores. Esto significa que edito el archivo "/etc/dphys-swapfile" y pongo el atributo "CONF_SWAPSIZE" a "0".
{{< gallery match="images/4/*.png" >}}
>Además, hay que ajustar la configuración de "Control-Group" en el archivo "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Ver:
{{< gallery match="images/5/*.png" >}}
>Ahora todas las Raspberrys deberían reiniciarse una vez y están listas para la instalación de Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Después del reinicio, instalo estos paquetes en el servidor 1, el servidor 2 y el servidor 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Sólo el servidor 1
Ahora se puede inicializar el maestro Kubenetes.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Después de la inicialización exitosa, acepto los ajustes. Recuerdo el comando "kubeadm join" mostrado para conectar los nodos trabajadores.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Ahora, por desgracia, hay que hacer algo por la red.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>El comando "kubectl get nodes" debería mostrar ahora el "Master" en estado "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Añadir nodos
Ahora necesitamos el comando "kubeadm join" de la inicialización de Kubenetes. Introduzco este comando en el "Servidor 2" y en el "Servidor 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Si ahora introduzco de nuevo el comando "kubectl get nodes" desde el "Servidor 1", estos nodos probablemente se muestren en el estado "No listo". Aquí también está el problema de la red que también tenía el maestro. Vuelvo a ejecutar el comando de antes, pero esta vez añado una "f" de fuerza.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Después de eso, veo todos los nodos listos para su uso.
{{< gallery match="images/6/*.png" >}}

## Pequeño despliegue de pruebas (Servidor 1/Kubenetes-Master)
Escribo yo mismo un pequeño despliegue de prueba y compruebo las funciones. Creo un archivo "nginx.yml" con el siguiente contenido:
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
Ahora empiezo la depliación:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>¡Genial!
{{< gallery match="images/7/*.png" >}}
Creo un servicio y puedo llamar a mi contenedor.
{{< gallery match="images/8/*.png" >}}
Una vez escalado a 20 "réplicas":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Ver:
{{< gallery match="images/9/*.png" >}}

## Limpiar la aplicación de las pruebas
Para poner orden, borro el deplyment y el servicio de nuevo.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Ver:
{{< gallery match="images/10/*.png" >}}
