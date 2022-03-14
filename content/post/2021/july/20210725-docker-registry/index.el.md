+++
date = "2021-07-25"
title = "Μεγάλα πράγματα με δοχεία: Μητρώο Docker με UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.el.md"
+++
Μάθετε πώς να κάνετε τις εικόνες σας Docker διαθέσιμες σε όλο το δίκτυο μέσω του δικού σας μητρώου.
## Εγκατάσταση
Δημιουργώ έναν νέο κατάλογο με όνομα "docker-registry" στον διακομιστή μου:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Στη συνέχεια πηγαίνω στον κατάλογο docker-registry ("cd docker-registry") και δημιουργώ ένα νέο αρχείο με όνομα "registry.yml" με το ακόλουθο περιεχόμενο:
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Η εντολή start
Αυτό το αρχείο εκκινείται μέσω του Docker Compose. Στη συνέχεια, η εγκατάσταση είναι προσβάσιμη από τον προβλεπόμενο τομέα/θυρίδα.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Στη συνέχεια, το δικό σας μητρώο μπορεί να χρησιμοποιηθεί με τη διεύθυνση IP και τη θύρα προορισμού του περιέκτη UI.
{{< gallery match="images/1/*.png" >}}
Τώρα μπορώ να δημιουργήσω, να προωθήσω και να συμπληρώσω εικόνες από το μητρώο μου:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
