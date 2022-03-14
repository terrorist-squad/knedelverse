+++
date = "2021-06-20"
title = "Grandes coisas com contentores: aglomerado Kubenetes e armazenamento NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210620-pi-kubenetes-cloud/index.pt.md"
+++
Hoje estou instalando um novo cluster Kubenetes e há muito o que fazer!
{{< gallery match="images/1/*.jpg" >}}
Eu encomendei estes componentes para ele:
- 1x WDBU6Y0050BBK Elementos WD portáteis 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- Ventilador 3x, duplo: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x unidades de fornecimento de energia: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 peças Kit de ficha Dupont: https://amzn.to/3kcfYqQ
- 1x LED verde com resistor de série: https://amzn.to/3EQgXVp
- 1x LED azul com resistor de série: https://amzn.to/31ChYSO
- 10x Marquardt 203.007.013 Blanking piece Black: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x base de lâmpada: https://amzn.to/3H0UZkG
## Vamos lá!

{{< youtube ulzMoX-fpvc >}}
Eu criei minha própria imagem para a instalação com base na instalação Raspian Lite. O meu utilizador/chave pública já está guardado nesta imagem e o ficheiro "/boot/config.txt" foi adaptado para os meus LEDs.
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

## Servidor 1 - Montagem de disco
Primeiro, eu instalo um serviço NFS no "Server 1". Este armazenamento pode ser usado mais tarde para o meu conjunto de contentores. Liguei o disco rígido USB ao "Server 1" e formatei-o EXT4 com a ajuda das seguintes instruções: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Depois criei um ponto de montagem para o disco USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Eu entrei o novo sistema de arquivo no arquivo "/etc/fstab" da seguinte forma:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
A configuração pode ser verificada com "sudo mount -a". Agora o disco USB deve ser montado em "/media/usb-disk".
##  Instalar NFS
Este pacote é necessário para o NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Além disso, foi criada uma nova pasta no disco USB
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Então o arquivo "/etc/exports" deve ser editado. O caminho, o ID do usuário e o ID do grupo são entrados ali:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Agora a configuração pode ser adotada da seguinte forma.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Como eu posso montar o NFS?
Eu posso montar o volume da seguinte forma:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Ou digite permanentemente no arquivo "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Aqui também, posso usar "sudo mount -a".
## Instalar Kubernetes
Os seguintes comandos devem ser executados no servidor 1, servidor 2 e servidor 3. Primeiro instalamos o Docker e adicionamos o usuário "PI" ao grupo Docker.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
> Após isso, a configuração do tamanho do swap é zerada em todos os servidores. Isto significa que eu edito o ficheiro "/etc/dphys-swapfile" e defino o atributo "CONF_SWAPSIZE" para "0".
{{< gallery match="images/4/*.png" >}}
>Além disso, as configurações do "Control-Group" no arquivo "/boot/cmdline.txt" devem ser ajustadas:
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Veja:
{{< gallery match="images/5/*.png" >}}
>Agora todos os Raspberrys devem reiniciar uma vez e estão então prontos para a instalação Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
> Após a reinicialização, instalo estes pacotes no servidor 1, servidor 2 e servidor 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Servidor 1 apenas
Agora o mestre Kubenetes pode ser rubricado.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Após a inicialização bem sucedida, eu aceito as configurações. Lembro-me do comando "kubeadm join" exibido para conectar os nós de trabalhadores.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Agora, infelizmente, algo tem de ser feito para a rede.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>O comando "kubectl get nodes" deve agora mostrar o "Mestre" em estado "Pronto".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - Adicionar nós
Agora precisamos do comando "kubeadm join" da inicialização de Kubenetes. Introduzo este comando em "Servidor 2" e "Servidor 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Se eu agora entrar novamente com o comando "kubectl get nodes" do "Server 1", estes nós são provavelmente exibidos no status "Not Ready". Aqui, também, há o problema de rede que o mestre também tinha. Eu comando de antes novamente, mas desta vez eu adiciono um "f" de força.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Depois disso, vejo todos os nós prontos para uso.
{{< gallery match="images/6/*.png" >}}

## Pequeno teste deplyment (Servidor 1/Kubenetes-Master)
Eu mesmo escrevo um pequeno teste de implantação e verifico as funções. Eu crio um arquivo "nginx.yml" com o seguinte conteúdo:
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
Agora começo a deplorar:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Grande!
{{< gallery match="images/7/*.png" >}}
Eu crio um serviço e posso chamar o meu contentor.
{{< gallery match="images/8/*.png" >}}
Aumentei a escala de uma vez para 20 "réplicas":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Veja:
{{< gallery match="images/9/*.png" >}}

## Teste de limpeza deplorável
Para arrumar, eu apago o deplorável e o serviço novamente.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Veja:
{{< gallery match="images/10/*.png" >}}
