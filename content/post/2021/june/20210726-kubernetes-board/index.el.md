+++
date = "2021-06-26"
title = "Μεγάλα πράγματα με κοντέινερ: Kubernetes Dashboard"
difficulty = "level-4"
tags = ["kubernetes", "cloud", "homelab", "pods", "nodes", "raspberry-pi", "raspberry"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210726-kubernetes-board/index.el.md"
+++
Μετά τη δημιουργία ενός cluster Kubernetes στο σεμινάριο [Μεγάλα πράγματα με κοντέινερ: συστάδα Kubenetes και αποθήκευση NFS]({{< ref "post/2021/june/20210620-pi-kubenetes-cloud" >}} "Μεγάλα πράγματα με κοντέινερ: συστάδα Kubenetes και αποθήκευση NFS"), θα ήθελα να εγκαταστήσω ένα dashboard Kubernetes.
{{< gallery match="images/1/*.jpg" >}}
Αυτή η εντολή περιέχει όλα όσα χρειάζομαι για το έργο μου:
{{< terminal >}}
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

{{</ terminal >}}
Δεδομένου ότι η σχετική υπηρεσία δεν είναι προσβάσιμη από το εξωτερικό, ο κόμβος ".spec.type" πρέπει να αλλάξει.
{{< terminal >}}
kubectl -n kube-system edit service kubernetes-dashboard --namespace=kubernetes-dashboard

{{</ terminal >}}
Ο κόμβος ".spec.type" πρέπει να είναι "NodePort".
{{< gallery match="images/2/*.png" >}}
Μετά από αυτό, ο πίνακας οργάνων είναι ήδη προσβάσιμος:
{{< gallery match="images/3/*.png" >}}
Για να λάβετε το κουπόνι πρόσβασης, πρέπει να αναζητήσετε ένα κλειδί ελεγκτή ανάπτυξης:
{{< terminal >}}
kubectl -n kube-system get secret | grep deployment-controller-token

{{</ terminal >}}
Στη συνέχεια, μπορείτε να εμφανίσετε και να αντιγράψετε το διακριτικό.
{{< terminal >}}
kubectl -n kube-system describe secret deployment-controller-token-g7qdm

{{</ terminal >}}

{{< gallery match="images/4/*.png" >}}

{{< youtube TT6rpHq5Z7k  >}}