+++
date = "2021-06-26"
title = "Great things with containers: Kubernetes dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.en.md"
+++
After creating a Kubernetes - cluster in the [Great things with containers: Kubenetes cluster and NFS storage]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Great things with containers: Kubenetes cluster and NFS storage") tutorial, I want to install a Kubernetes dashboard.
{{< gallery match="images/1/*.jpg" >}}
This command has everything I need to do what I want to do:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Since the associated service is not accessible from the outside, the ".spec.type" node must still be changed.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
The node ".spec.type" must be "NodePort".
{{< gallery match="images/2/*.png" >}}
After that, the dashboard is already accessible:
{{< gallery match="images/3/*.png" >}}
To get the access token, you need to find a deployment controller key:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
After that you can display and copy the token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}