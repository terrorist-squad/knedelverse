+++
date = "2021-03-21"
title = "Cooles avec Atlassian : utiliser Bamboo et jMeter sans plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.fr.md"
+++
Aujourd'hui, je crée un test jMeter dans Bamboo. Bien entendu, cette configuration de test peut également être mise en place avec des runners Gitlab ou des esclaves Jenkins.
## Étape 1 : créer un test jMeter
La première chose à faire est bien sûr de créer un test jMeter. J'ai téléchargé jMeter à l'url suivante https://jmeter.apache.org/ et je l'ai lancé avec cette commande :
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Voir:Mon test de démonstration pour ce tutoriel doit contenir des échantillonneurs défectueux et fonctionnels. J'ai volontairement fixé des délais d'attente très bas.
{{< gallery match="images/2/*.png" >}}
J'utilise le fichier JMX pour enregistrer ma tâche Bamboo.
## Étape 2 : Préparer l'agent Bamboo
Comme Java est la condition préalable aux agents Bamboo, je ne fais qu'installer Python par la suite.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Je crée un nouveau travail et une tâche shell.
{{< gallery match="images/3/*.png" >}}
Et insère ce script shell :
```
#!/bin/bash
java -jar /tools/apache-jmeter-5.4.1/bin/ApacheJMeter.jar -n -t test.jmx -l requests.log > result.log

echo "Ergebnis:"
cat result.log

if cat result.log | python /tools/check.py > /dev/null; 
then
    echo "Proceed... Alles Prima!"
    exit 0
else
    echo "Returned an error.... Oje!"
    exit 1
fi

```
Le répertoire des outils est fixe sur la machine et ne fait pas partie du référentiel du projet. En outre, j'utilise ce script Python :
```
#!/usr/bin/python
import re
import sys
 
for line in sys.stdin:
    print line,
    match = re.search('summary =[\s].*Err:[ ]{0,10}([1-9]\d{0,10})[ ].*',line)
    print 'Check in line if Err: > 0 -> if so Error occured -> Test fails: '
    print match
    if match :
        print "exit 1"
        sys.exit(1)
print "nothing found - exit 0"
sys.exit(0)

```
Je crée également un modèle d'artefact pour les logs de résultats.
{{< gallery match="images/4/*.png" >}}

## Prêt !
Je peux maintenant effectuer mon travail. Après avoir modifié les délais d'attente, le test est également "vert".
{{< gallery match="images/5/*.png" >}}