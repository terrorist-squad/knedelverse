+++
date = "2021-06-26"
title = "Lucruri grozave cu containere: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.ro.md"
+++
După ce am creat un cluster Kubernetes în tutorialul [Lucruri grozave cu containere: cluster Kubenetes și stocare NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Lucruri grozave cu containere: cluster Kubenetes și stocare NFS"), aș dori să instalez un tablou de bord Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Această comandă conține tot ceea ce am nevoie pentru proiectul meu:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Deoarece serviciul asociat nu este accesibil din exterior, nodul ".spec.type" trebuie totuși modificat.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Nodul ".spec.type" trebuie să fie "NodePort".
{{< gallery match="images/2/*.png" >}}
După aceea, tabloul de bord este deja accesibil:
{{< gallery match="images/3/*.png" >}}
Pentru a obține jetonul de acces, trebuie să căutați o cheie de controler de implementare:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Apoi puteți afișa și copia simbolul.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}