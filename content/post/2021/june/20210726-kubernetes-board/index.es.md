+++
date = "2021-06-26"
title = "Grandes cosas con contenedores: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.es.md"
+++
Después de crear un clúster de Kubernetes en el tutorial de [Grandes cosas con contenedores: clúster Kubenetes y almacenamiento NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Grandes cosas con contenedores: clúster Kubenetes y almacenamiento NFS"), me gustaría instalar un panel de control de Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Este comando contiene todo lo que necesito para mi proyecto:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Dado que el servicio asociado no es accesible desde el exterior, el nodo ".spec.type" debe modificarse igualmente.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
El nodo ".spec.type" debe ser "NodePort".
{{< gallery match="images/2/*.png" >}}
Después de eso, el tablero de instrumentos ya es accesible:
{{< gallery match="images/3/*.png" >}}
Para obtener el token de acceso, hay que buscar una clave de controlador de despliegue:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
A continuación, puede visualizar y copiar el token.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}
