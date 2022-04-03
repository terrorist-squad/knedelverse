+++
date = "2021-06-26"
title = "Veľké veci s kontajnermi: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.sk.md"
+++
Po vytvorení klastra Kubernetes v návode [Veľké veci s kontajnermi: Kubenetes cluster a ukladanie NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Veľké veci s kontajnermi: Kubenetes cluster a ukladanie NFS") by som chcel nainštalovať ovládací panel Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Tento príkaz obsahuje všetko, čo potrebujem pre svoj projekt:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Keďže pridružená služba nie je prístupná zvonku, uzol ".spec.type" sa musí ešte zmeniť.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Uzol ".spec.type" musí byť "NodePort".
{{< gallery match="images/2/*.png" >}}
Potom je už prístrojová doska prístupná:
{{< gallery match="images/3/*.png" >}}
Ak chcete získať prístupový token, musíte vyhľadať kľúč radiča nasadenia:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Potom môžete zobraziť a skopírovať token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
