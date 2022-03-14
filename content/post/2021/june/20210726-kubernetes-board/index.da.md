+++
date = "2021-06-26"
title = "Store ting med containere: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.da.md"
+++
Efter at have oprettet en Kubernetes-klynge i [Store ting med containere: Kubenetes klynge og NFS-lagring]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Store ting med containere: Kubenetes klynge og NFS-lagring")-tutorialet vil jeg gerne installere et Kubernetes-dashboard.
{{< gallery match="images/1/*.jpg" >}}
Denne kommando indeholder alt, hvad jeg har brug for til mit projekt:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Da den tilknyttede tjeneste ikke er tilgængelig udefra, skal noden ".spec.type" stadig ændres.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Noden ".spec.type" skal være "NodePort".
{{< gallery match="images/2/*.png" >}}
Herefter er instrumentbrættet allerede tilgængeligt:
{{< gallery match="images/3/*.png" >}}
For at få adgangstokenet skal man søge efter en nøgle til en implementeringscontroller:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Derefter kan du vise og kopiere tokenet.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}