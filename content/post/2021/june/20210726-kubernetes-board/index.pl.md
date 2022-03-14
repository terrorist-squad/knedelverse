+++
date = "2021-06-26"
title = "Wspaniałe rzeczy z kontenerami: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.pl.md"
+++
Po utworzeniu klastra Kubernetes w tutorialu [Wielkie rzeczy z kontenerami: klaster Kubenetes i magazyn NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Wielkie rzeczy z kontenerami: klaster Kubenetes i magazyn NFS"), chciałbym zainstalować dashboard Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
To polecenie zawiera wszystko, czego potrzebuję do mojego projektu:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Ponieważ powiązana usługa nie jest dostępna z zewnątrz, węzeł ".spec.type" musi zostać zmieniony.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Węzeł ".spec.type" musi mieć wartość "NodePort".
{{< gallery match="images/2/*.png" >}}
Po tym, deska rozdzielcza jest już dostępna:
{{< gallery match="images/3/*.png" >}}
Aby uzyskać token dostępu, należy odszukać klucz kontrolera wdrażania:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Następnie można wyświetlić i skopiować token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}