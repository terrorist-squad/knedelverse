+++
date = "2021-06-26"
title = "Großartiges mit Containern: Kubernetes-Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.de.md"
+++

Nachdem ich im  [Großartiges mit Containern: Kubenetes-Cluster und NFS-Speicher]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Großartiges mit Containern: Kubenetes-Cluster und NFS-Speicher")-Tutorial ein Kubernetes - Cluster erzeugt habe, möchte ich ein ein Kubernetes-Dashboard installieren.
{{< gallery match="images/1/*.jpg" >}}



In diesem Befehl steckt alles, was ich für mein Vorhaben brauche:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
{{</ terminal >}}

Da der dazugehörige Service nicht von außen erreichbar ist, muss noch der Knoten ".spec.type" geändert werden.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard
{{</ terminal >}}
Der Knoten ".spec.type" muss "NodePort" sein.
{{< gallery match="images/2/*.png" >}}

Danach ist das Dashboard bereits erreichbar:
{{< gallery match="images/3/*.png" >}}

Um den Zugriffs-Token zu bekommen, muss man eine Deployment-Controller-Schlüssel suchen:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token
{{</ terminal >}}
Danach kann man sich den Token anzeigen lassen und kopieren.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm
{{</ terminal >}}
{{< gallery match="images/4/*.png" >}}
{{< youtube TT6rpHq5Z7k  >}}