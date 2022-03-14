+++
date = "2021-03-21"
title = "Leuke dingen met Atlassian: Bamboo en jMeter gebruiken zonder plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.nl.md"
+++
Vandaag maak ik een jMeter-test in Bamboo. Natuurlijk kun je deze testopstelling ook implementeren met Gitlab runners of Jenkins slaves.
## Stap 1: Maak jMeter test
Eerst, natuurlijk, moet je een jMeter test maken. Ik heb jMeter gedownload van de volgende url https://jmeter.apache.org/ en heb het opgestart met dit commando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Zie: Mijn demotest voor deze tutorial is bedoeld om defecte en werkende samplers te bevatten. Ik heb de time-outs expres heel laag gezet.
{{< gallery match="images/2/*.png" >}}
Ik sla op met het JMX-bestand voor mijn Bamboo-taak.
## Stap 2: Bereid het bamboemiddel voor
Aangezien Java een vereiste is voor Bamboo agents, installeer ik Python pas daarna.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Ik maak een nieuwe job en een shell taak.
{{< gallery match="images/3/*.png" >}}
En voeg dit shell script in:
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
De gereedschapsdirectory staat vast op de machine en maakt geen deel uit van de projectrepository. Daarnaast gebruik ik dit Python script:
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
Ik maak ook een artefact patroon voor de resultaat logs.
{{< gallery match="images/4/*.png" >}}

## Klaar!
Nu kan ik mijn werk doen. Nadat ik de time-outs heb veranderd, is de test ook "groen".
{{< gallery match="images/5/*.png" >}}