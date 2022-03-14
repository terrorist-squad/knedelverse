+++
date = "2021-06-26"
title = "Nagyszerű dolgok konténerekkel: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.hu.md"
+++
Miután létrehoztam egy Kubernetes fürtöt az [Nagyszerű dolgok konténerekkel: Kubenetes fürt és NFS tárolás]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Nagyszerű dolgok konténerekkel: Kubenetes fürt és NFS tárolás") bemutatóban, szeretnék telepíteni egy Kubernetes dashboardot.
{{< gallery match="images/1/*.jpg" >}}
Ez a parancs mindent tartalmaz, amire szükségem van a projektemhez:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Mivel a kapcsolódó szolgáltatás kívülről nem érhető el, a ".spec.type" csomópontot továbbra is módosítani kell.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
A ".spec.type" csomópontnak "NodePort"-nak kell lennie.
{{< gallery match="images/2/*.png" >}}
Ezt követően a műszerfal már elérhető:
{{< gallery match="images/3/*.png" >}}
A hozzáférési token megszerzéséhez meg kell keresni a telepítési vezérlő kulcsát:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Ezután megjelenítheti és másolhatja a tokent.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}