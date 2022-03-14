+++
date = "2021-06-26"
title = "Suuria asioita konttien kanssa: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.fi.md"
+++
Kun olen luonut Kubernetes-klusterin [Hienoja asioita konttien kanssa: Kubenetes-klusteri ja NFS-tallennustila]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Hienoja asioita konttien kanssa: Kubenetes-klusteri ja NFS-tallennustila")-oppaassa, haluan asentaa Kubernetes-kojelaudan.
{{< gallery match="images/1/*.jpg" >}}
Tämä komento sisältää kaiken, mitä tarvitsen projektissani:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Koska siihen liittyvään palveluun ei pääse käsiksi ulkopuolelta, ".spec.type"-solmua on silti muutettava.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Solmun ".spec.type" on oltava "NodePort".
{{< gallery match="images/2/*.png" >}}
Sen jälkeen kojelauta on jo käytettävissä:
{{< gallery match="images/3/*.png" >}}
Pääsykoodin saamiseksi on etsittävä käyttöönoton ohjaimen avain:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Sitten voit näyttää ja kopioida merkin.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}