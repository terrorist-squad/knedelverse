+++
date = "2021-06-26"
title = "Grandes coisas com recipientes: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.pt.md"
+++
Depois de criar um cluster Kubernetes no tutorial [Grandes coisas com contentores: aglomerado Kubenetes e armazenamento NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandes coisas com contentores: aglomerado Kubenetes e armazenamento NFS"), eu gostaria de instalar um painel de controlo Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Este comando contém tudo o que eu preciso para o meu projecto:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Como o serviço associado não é acessível de fora, o nó ".spec.type" ainda deve ser alterado.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
O nó ".spec.type" deve ser "NodePort".
{{< gallery match="images/2/*.png" >}}
Depois disso, o tablier já está acessível:
{{< gallery match="images/3/*.png" >}}
Para obter o token de acesso, é preciso procurar uma chave de controle de implantação:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Então você pode exibir e copiar a ficha.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
