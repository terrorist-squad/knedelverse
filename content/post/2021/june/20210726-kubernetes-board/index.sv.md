+++
date = "2021-06-26"
title = "Stora saker med behållare: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.sv.md"
+++
Efter att ha skapat ett Kubernetes-kluster i [Stora saker med containrar: Kubenetes kluster och NFS-lagring]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Stora saker med containrar: Kubenetes kluster och NFS-lagring")-handledningen vill jag installera en Kubernetes-instrumentpanel.
{{< gallery match="images/1/*.jpg" >}}
Detta kommando innehåller allt jag behöver för mitt projekt:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Eftersom den associerade tjänsten inte är tillgänglig utifrån måste noden ".spec.type" ändå ändras.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Noden ".spec.type" måste vara "NodePort".
{{< gallery match="images/2/*.png" >}}
Därefter är instrumentpanelen redan tillgänglig:
{{< gallery match="images/3/*.png" >}}
För att få tillgångstoken måste man söka efter en nyckel för distributionsstyrning:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Därefter kan du visa och kopiera tokenet.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
