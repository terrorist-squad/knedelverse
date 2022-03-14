+++
date = "2021-06-26"
title = "Du grand avec les conteneurs : tableau de bord Kubernetes"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.fr.md"
+++
Après avoir créé un cluster Kubernetes dans le tutoriel [Du grand avec les conteneurs : cluster Kubenetes et stockage NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Du grand avec les conteneurs : cluster Kubenetes et stockage NFS"), je souhaite installer un tableau de bord Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Cet ordre contient tout ce dont j'ai besoin pour mon projet :
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Comme le service correspondant n'est pas accessible de l'extérieur, il faut encore modifier le nœud ".spec.type".
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Le nœud ".spec.type" doit être "NodePort".
{{< gallery match="images/2/*.png" >}}
Ensuite, le tableau de bord est déjà accessible :
{{< gallery match="images/3/*.png" >}}
Pour obtenir le jeton d'accès, il faut chercher une clé de contrôleur de déploiement :
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Ensuite, il est possible d'afficher le jeton et de le copier.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}