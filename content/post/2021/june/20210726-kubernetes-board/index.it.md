+++
date = "2021-06-26"
title = "Grandi cose con i container: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.it.md"
+++
Dopo aver creato un cluster Kubernetes nel tutorial [Grandi cose con i container: cluster Kubenetes e storage NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandi cose con i container: cluster Kubenetes e storage NFS"), vorrei installare una dashboard Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Questo comando contiene tutto ciò di cui ho bisogno per il mio progetto:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Poiché il servizio associato non è accessibile dall'esterno, il nodo ".spec.type" deve ancora essere cambiato.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Il nodo ".spec.type" deve essere "NodePort".
{{< gallery match="images/2/*.png" >}}
Dopo di che, il cruscotto è già accessibile:
{{< gallery match="images/3/*.png" >}}
Per ottenere il token di accesso, si deve cercare una chiave del deployment controller:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Poi puoi visualizzare e copiare il token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
