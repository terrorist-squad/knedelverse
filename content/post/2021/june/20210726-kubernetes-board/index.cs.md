+++
date = "2021-06-26"
title = "Skvělé věci s kontejnery: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.cs.md"
+++
Po vytvoření clusteru Kubernetes v tutoriálu [Skvělé věci s kontejnery: cluster Kubenetes a úložiště NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Skvělé věci s kontejnery: cluster Kubenetes a úložiště NFS") bych rád nainstaloval ovládací panel Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Tento příkaz obsahuje vše, co potřebuji pro svůj projekt:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Protože přidružená služba není přístupná zvenčí, je třeba ještě změnit uzel ".spec.type".
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Uzel ".spec.type" musí být "NodePort".
{{< gallery match="images/2/*.png" >}}
Poté je již přístrojová deska přístupná:
{{< gallery match="images/3/*.png" >}}
Pro získání přístupového tokenu je třeba vyhledat klíč řadiče nasazení:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Pak můžete token zobrazit a zkopírovat.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
