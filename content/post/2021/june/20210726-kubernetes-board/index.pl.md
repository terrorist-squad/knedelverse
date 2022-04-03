+++
date = "2021-06-26"
title = "Wspaniałe rzeczy z kontenerami: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.pl.md"
+++
Po utworzeniu klastra Kubernetes w samouczku [Wspaniałe rzeczy z kontenerami: klaster Kubenetes i pamięć masowa NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Wspaniałe rzeczy z kontenerami: klaster Kubenetes i pamięć masowa NFS") chciałbym zainstalować pulpit nawigacyjny Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
To polecenie zawiera wszystko, co jest potrzebne w moim projekcie:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Ponieważ powiązana usługa nie jest dostępna z zewnątrz, węzeł ".spec.type" musi zostać zmieniony.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Węzeł ".spec.type" musi mieć wartość "NodePort".
{{< gallery match="images/2/*.png" >}}
Po wykonaniu tych czynności tablica rozdzielcza jest już dostępna:
{{< gallery match="images/3/*.png" >}}
Aby uzyskać token dostępu, należy wyszukać klucz kontrolera obrazu stanowiska:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Następnie można wyświetlić i skopiować token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
