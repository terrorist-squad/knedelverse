+++
date = "2021-06-26"
title = "容器的伟大之处：Kubernetes仪表板"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.zh.md"
+++
在[容器的伟大之处：Kubenetes集群和NFS存储]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "容器的伟大之处：Kubenetes集群和NFS存储")教程中创建了一个Kubernetes集群后，我想安装一个Kubernetes仪表板。
{{< gallery match="images/1/*.jpg" >}}
这个命令包含我的项目所需要的一切。
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
由于相关服务不能从外部访问，".spec.type "节点仍然必须被改变。
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
节点".spec.type "必须是 "NodePort"。
{{< gallery match="images/2/*.png" >}}
之后，仪表盘已经可以访问。
{{< gallery match="images/3/*.png" >}}
为了获得访问令牌，人们必须寻找一个部署控制器的密钥。
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
然后你就可以显示和复制该令牌。
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}