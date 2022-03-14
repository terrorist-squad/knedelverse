+++
date = "2021-06-26"
title = "Velike stvari s kontejnerji: nadzorna plošča Kubernetes"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.sl.md"
+++
Po ustvarjanju gruče Kubernetes v vodniku [Velike stvari z zabojniki: Kubenetesova gruča in shranjevanje NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Velike stvari z zabojniki: Kubenetesova gruča in shranjevanje NFS") želim namestiti nadzorno ploščo Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Ta ukaz vsebuje vse, kar potrebujem za svoj projekt:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Ker povezana storitev ni dostopna od zunaj, je treba vozlišče ".spec.type" še vedno spremeniti.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Vozlišče ".spec.type" mora biti "NodePort".
{{< gallery match="images/2/*.png" >}}
Po tem je armaturna plošča že dostopna:
{{< gallery match="images/3/*.png" >}}
Za pridobitev žetona dostopa je treba poiskati ključ namestitvenega krmilnika:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Nato lahko prikažete in kopirate žeton.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}