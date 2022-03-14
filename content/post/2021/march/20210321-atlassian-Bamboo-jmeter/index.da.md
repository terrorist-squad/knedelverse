+++
date = "2021-03-21"
title = "Fede ting med Atlassian: brug af Bamboo og jMeter uden plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.da.md"
+++
I dag er jeg ved at oprette en jMeter-test i Bamboo. Du kan naturligvis også implementere denne testopsætning med Gitlab-runnere eller Jenkins-slaves.
## Trin 1: Opret jMeter-test
Først skal du selvfølgelig oprette en jMeter-test. Jeg downloadede jMeter fra følgende url https://jmeter.apache.org/ og startede det med denne kommando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Se:Min demotest til denne vejledning er beregnet til at indeholde fejlbehæftede og fungerende samplere. Jeg har med vilje sat timeouts meget lavt.
{{< gallery match="images/2/*.png" >}}
Jeg gemmer med JMX-filen til min Bamboo-opgave.
## Trin 2: Forbered bambusmiddel
Da Java er en forudsætning for Bamboo-agenter, installerer jeg først Python bagefter.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Jeg opretter et nyt job og en shell-opgave.
{{< gallery match="images/3/*.png" >}}
Og indsæt dette shell-script:
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
Værktøjskataloget er fast installeret på maskinen og er ikke en del af projektopbevaringsarkivet. Derudover bruger jeg dette Python-script:
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
Jeg opretter også et artefaktmønster for resultatlogfilerne.
{{< gallery match="images/4/*.png" >}}

## Klar!
Nu kan jeg gøre mit arbejde. Efter at jeg ændrede timeouts, er testen også "grøn".
{{< gallery match="images/5/*.png" >}}