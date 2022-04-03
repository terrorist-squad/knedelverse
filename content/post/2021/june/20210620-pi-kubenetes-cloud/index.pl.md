+++
date = "2021-06-20"
title = "Wspaniałe rzeczy z kontenerami: klaster Kubenetes i pamięć masowa NFS"
difficulty = "level-4"
tags = ["kubernetes", "nfs", "filer", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210620-pi-kubenetes-cloud/index.pl.md"
+++
Dzisiaj instaluję nowy klaster Kubenetes i jest wiele do zrobienia!
{{< gallery match="images/1/*.jpg" >}}
Zamówiłem do niego te elementy:
- 1x WDBU6Y0050BBK WD Elements portable 5TB: https://www.reichelt.de/wd-elements-portable-5tb-wdbu6y0050bbk-p270625.html?
- 3x wentylator, podwójny: https://www.reichelt.de/raspberry-pi-luefter-dual-rpi-fan-dual-p223618.html?
- 1x Raspberry 4 / 4GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-4-gb-ram-wlan-bt-rasp-pi-4-b-4gb-p259920.html?
- 2x Raspberry 4 / 8GB Ram: https://www.reichelt.de/raspberry-pi-4-b-4x-1-5-ghz-8-gb-ram-wlan-bt-rasp-pi-4-b-8gb-p276923.html?
- 3x zasilacze: https://www.reichelt.de/raspberry-pi-netzteil-5-1-v-3-0-a-usb-type-c-eu-stecker-s-rpi-ps-15w-bk-eu-p260010.html
- 1x Rackmount: https://amzn.to/3H8vOg7
- 1x 600 sztuk zestaw korków Dupont: https://amzn.to/3kcfYqQ
- 1x zielona dioda LED z rezystorem szeregowym: https://amzn.to/3EQgXVp
- 1x niebieska dioda LED z rezystorem szeregowym: https://amzn.to/31ChYSO
- 10x zaślepka Marquardt 203.007.013 Czarny: https://www.voelkner.de/products/215024/Marquardt-203.007.013-Blindstueck-Schwarz.html
- 1x gniazdo lampy: https://amzn.to/3H0UZkG
## Ruszamy!

{{< youtube ulzMoX-fpvc >}}
Stworzyłem własny obraz instalacji oparty na instalacji Raspian Lite. Mój klucz użytkownika/publiczny jest już zapisany w tym obrazie, a plik "/boot/config.txt" został dostosowany do moich diod LED.
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

## Serwer 1 - zamontuj dysk
Najpierw instaluję usługę NFS na "Serwerze 1". Ta pamięć masowa może być później użyta w moim klastrze kontenerów. Podłączyłem dysk twardy USB do "Server 1" i sformatowałem go EXT4 za pomocą następujących instrukcji: https://homecircuits.eu/blog/mount-sata-cubieboard-lubuntu/
{{< gallery match="images/3/*.jpg" >}}
Następnie utworzyłem punkt montowania dla dysku USB:
{{< terminal >}}
sudo mkdir /media/usb-platte

{{</ terminal >}}
Wprowadziłem nowy system plików do pliku "/etc/fstab" w następujący sposób:
```
/dev/sda1 /media/usb-platte ext4 defaults 0 2

```
Ustawienie to można sprawdzić za pomocą polecenia "sudo mount -a". Teraz dysk USB powinien być zamontowany pod adresem "/media/usb-disk".
##  Zainstaluj NFS
Pakiet ten jest wymagany dla systemu NFS:
{{< terminal >}}
sudo apt-get install nfs-kernel-server -y

{{</ terminal >}}
>Ponadto na dysku USB został utworzony nowy folder
{{< terminal >}}
sudo mkdir /media/usb-platte/nfsshare
sudo chown -R pi:pi /media/usb-platte/nfsshare/
sudo find /media/usb-platte/nfsshare/ -type d -exec chmod 755 {} \;
sudo find /media/usb-platte/nfsshare/ -type f -exec chmod 644 {} \;

{{</ terminal >}}
>>Następnie należy edytować plik "/etc/exports". Wprowadza się tam ścieżkę, identyfikator użytkownika i identyfikator grupy:
```
/media/usb-platte/nfsshare *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)

```
>Teraz ustawienia można wprowadzić w następujący sposób.
{{< terminal >}}
sudo exportfs -ra

{{</ terminal >}}
>
##  Jak zamontować system NFS?
Wolumin można zamontować w następujący sposób:
{{< terminal >}}
sudo mount -t nfs SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs

{{</ terminal >}}
Można też wpisać na stałe do pliku "/etc/fstab":
```
SERVER-1-IP:/media/usb-platte/nfsshare /mnt/nfs/ nfs defaults 0 0

```
Również w tym przypadku mogę użyć polecenia "sudo mount -a".
## Zainstaluj Kubernetes
Poniższe polecenia muszą być wykonane na serwerach 1, 2 i 3. Najpierw instalujemy Dockera i dodajemy użytkownika "PI" do grupy Dockera.
{{< terminal >}}
curl -sSL get.docker.com | sh 
sudo usermod pi -aG docker

{{</ terminal >}}
>Następnie na wszystkich serwerach zostanie wyzerowane ustawienie rozmiaru wymiany. Oznacza to, że edytujemy plik "/etc/dphys-swapfile" i ustawiamy atrybut "CONF_SWAPSIZE" na "0".
{{< gallery match="images/4/*.png" >}}
>Ponadto należy dostosować ustawienia "Control-Group" w pliku "/boot/cmdline.txt":
```
cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

```
Zobacz:
{{< gallery match="images/5/*.png" >}}
>Teraz wszystkie komputery Raspberry powinny się zrestartować i są gotowe do instalacji Kubernetes.
{{< terminal >}}
sudo reboot

{{</ terminal >}}
>Po ponownym uruchomieniu komputera instaluję te pakiety na serwerach 1, 2 i 3:
{{< terminal >}}
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
sudo apt-get update -q && sudo apt-get install -qy kubeadm

{{</ terminal >}}
>
## # Tylko serwer 1
Teraz można zainicjować główny serwer Kubenetes.
{{< terminal >}}
sudo kubeadm init --token-ttl=0 --pod-network-cidr=10.244.0.0/16

{{</ terminal >}}
Po pomyślnej inicjalizacji akceptuję ustawienia. Pamiętam wyświetlane polecenie "kubeadm join" służące do łączenia węzłów robotniczych.
{{< terminal >}}
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

{{</ terminal >}}
Teraz, niestety, trzeba coś zrobić dla sieci.
{{< terminal >}}
kubectl apply https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
sudo systemctl daemon-reload
systemctl restart kubelet

{{</ terminal >}}
>Polecenie "kubectl get nodes" powinno teraz pokazać węzły "Master" w stanie "Ready".
{{< gallery match="images/6/*.png" >}}

## Kubernetes - dodawanie węzłów
Teraz potrzebujemy polecenia "kubeadm join" z inicjalizacji Kubenetes. Wprowadzam to polecenie na "Serwerze 2" i "Serwerze 3".
{{< terminal >}}
kubeadm join master-ip:port --token r4fddsfjdsjsdfomsfdoi --discovery-token-ca-cert-hash sha256:1adea3bfxfdfddfdfxfdfsdffsfdsdf946da811c27d1807aa

{{</ terminal >}}
Jeśli teraz ponownie wpiszę polecenie "kubectl get nodes" z "Server 1", węzły te zostaną prawdopodobnie wyświetlone w statusie "Not Ready". Również w tym przypadku występuje problem z siecią, który miał również mistrz. Ponownie uruchamiam poprzednie polecenie, ale tym razem dodaję literę "f" oznaczającą siłę.
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

{{</ terminal >}}
>Następnie widzę wszystkie węzły gotowe do użycia.
{{< gallery match="images/6/*.png" >}}

## Mała instalacja testowa (Serwer 1/Kubenetes-Master)
Piszę sobie małe wdrożenie testowe i sprawdzam działanie funkcji. Tworzę plik "nginx.yml" o następującej zawartości:
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
Teraz rozpoczynam depilację:
{{< terminal >}}
kubectl apply -f nginx.yml
kubectl rollout status deployment/my-nginx
kubectl get deplyments

{{</ terminal >}}
>Świetnie!
{{< gallery match="images/7/*.png" >}}
Tworzę usługę i mogę wywoływać mój kontener.
{{< gallery match="images/8/*.png" >}}
Jednorazowo skaluję do 20 "replik":
{{< terminal >}}
kubectl scale deployment my-nginx --replicas=0; kubectl scale deployment my-nginx --replicas=20

{{</ terminal >}}
>Zobacz:
{{< gallery match="images/9/*.png" >}}

## Uporządkowanie stanowiska badawczego
W celu uporządkowania usuwam ponownie wpłatę i usługę.
{{< terminal >}}
kubectl delete service example-service
kubectl delete deplyments my-nginx

{{</ terminal >}}
>Zobacz:
{{< gallery match="images/10/*.png" >}}

