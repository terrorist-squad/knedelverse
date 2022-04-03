+++
date = "2021-06-26"
title = "コンテナですごいこと：Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.ja.md"
+++
[コンテナですごいこと：KubenetesクラスタとNFSストレージ]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "コンテナですごいこと：KubenetesクラスタとNFSストレージ")チュートリアルでKubernetesクラスタを作成した後、Kubernetesダッシュボードをインストールしたいと思います。
{{< gallery match="images/1/*.jpg" >}}
このコマンドには、私のプロジェクトに必要なものがすべて含まれています。
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
関連するサービスは外部からアクセスできないため、やはり「.spec.type」ノードを変更する必要があります。
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
ノード「.spec.type」は "NodePort "でなければならない。
{{< gallery match="images/2/*.png" >}}
その後、すでにダッシュボードにアクセスできるようになっています。
{{< gallery match="images/3/*.png" >}}
アクセストークンを取得するには、デプロイメントコントローラーのキーを検索する必要があります。
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
そして、トークンを表示し、コピーすることができます。
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
