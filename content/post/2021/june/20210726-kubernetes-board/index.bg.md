+++
date = "2021-06-26"
title = "Страхотни неща с контейнери: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210726-kubernetes-board/index.bg.md"
+++
След като създадох клъстер Kubernetes в урока [Страхотни неща с контейнери: Kubenetes клъстер и NFS съхранение]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Страхотни неща с контейнери: Kubenetes клъстер и NFS съхранение"), искам да инсталирам табло за управление на Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Тази команда съдържа всичко, което ми е необходимо за моя проект:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Тъй като свързаната услуга не е достъпна отвън, възелът ".spec.type" все пак трябва да бъде променен.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Възелът ".spec.type" трябва да бъде "NodePort".
{{< gallery match="images/2/*.png" >}}
След това таблото за управление вече е достъпно:
{{< gallery match="images/3/*.png" >}}
За да получите токена за достъп, трябва да потърсите ключ на контролера за внедряване:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
След това можете да покажете и копирате символа.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}