+++
date = "2020-02-07"
title = "Brève histoire : Scripts Bash avec Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.fr.md"
+++
Si l'on veut intégrer un script bash dans la platine stream d'Elgato, il faut d'abord un script bash.
## Étape 1 : Créer un script bash :
Je crée un fichier nommé "say-hallo.sh" avec le contenu suivant :
```
#!/bin/bash
say "hallo"

```

## Étape 2 : Définir les droits
La commande suivante permet de rendre le fichier exécutable :
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Étape 3 : inclure le script bash dans le deck
3.1) L'application Stream Deck peut maintenant être ouverte :
{{< gallery match="images/1/*.png" >}}
3.2) Ensuite, je fais glisser l'action "Système:ouvrir" sur un bouton
{{< gallery match="images/2/*.png" >}}
3.3) Je peux maintenant choisir mon script bash :
{{< gallery match="images/3/*.png" >}}

## Étape 4 : Fini !
