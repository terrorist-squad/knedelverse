+++
date = "2021-06-26"
title = "Geweldige dingen met containers: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.nl.md"
+++
Nadat ik een Kubernetes cluster heb gemaakt in de [Geweldige dingen met containers: Kubenetes cluster en NFS opslag]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Geweldige dingen met containers: Kubenetes cluster en NFS opslag") tutorial, wil ik een Kubernetes dashboard installeren.
{{< gallery match="images/1/*.jpg" >}}
Dit commando bevat alles wat ik nodig heb voor mijn project:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Aangezien de bijbehorende dienst niet van buitenaf toegankelijk is, moet de ".spec.type"-knoop nog worden gewijzigd.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Het knooppunt ".spec.type" moet "NodePort" zijn.
{{< gallery match="images/2/*.png" >}}
Daarna is het dashboard al toegankelijk:
{{< gallery match="images/3/*.png" >}}
Om het toegangstoken te krijgen, moet er gezocht worden naar een deployment controller sleutel:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Dan kunt u het token weergeven en kopiëren.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
