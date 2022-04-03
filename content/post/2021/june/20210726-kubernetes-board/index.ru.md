+++
date = "2021-06-26"
title = "Великие дела с контейнерами: панель Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.ru.md"
+++
После создания кластера Kubernetes в руководстве [Большие вещи с контейнерами: кластер Kubenetes и хранилище NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Большие вещи с контейнерами: кластер Kubenetes и хранилище NFS") я хотел бы установить панель Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Эта команда содержит все необходимое для моего проекта:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Поскольку связанная служба недоступна извне, узел ".spec.type" все равно должен быть изменен.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Узел ".spec.type" должен быть "NodePort".
{{< gallery match="images/2/*.png" >}}
После этого приборная панель уже доступна:
{{< gallery match="images/3/*.png" >}}
Чтобы получить маркер доступа, необходимо найти ключ контроллера развертывания:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Затем вы можете отобразить и скопировать маркер.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
