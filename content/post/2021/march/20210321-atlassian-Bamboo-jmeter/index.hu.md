+++
date = "2021-03-21"
title = "Király dolgok az Atlassian-nal: a Bamboo és a jMeter használata pluginok nélkül"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.hu.md"
+++
Ma egy jMeter tesztet készítek a Bamboo-ban. Természetesen ez a tesztelési beállítás Gitlab futókkal vagy Jenkins szolgákkal is megvalósítható.
## 1. lépés: jMeter teszt létrehozása
Először természetesen létre kell hoznod egy jMeter tesztet. Letöltöttem a jMeter-t a következő url-ről: https://jmeter.apache.org/ és ezzel a paranccsal indítottam el:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Lásd:Az ehhez a bemutatóhoz készített demó tesztem hibás és működő mintavevő eszközöket tartalmaz. Az időkorlátokat szándékosan nagyon alacsonyra állítottam.
{{< gallery match="images/2/*.png" >}}
A JMX-fájllal mentem a Bamboo-feladatomhoz.
## 2. lépés: Készítsük elő a bambusz ügynököt
Mivel a Java a Bamboo-ügynökök előfeltétele, a Pythont csak utána telepítem.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Létrehozok egy új feladatot és egy héjfeladatot.
{{< gallery match="images/3/*.png" >}}
És illessze be ezt a shell scriptet:
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
Az eszközkönyvtár a gépen van rögzítve, és nem része a projekttárnak. Ezenkívül ezt a Python szkriptet használom:
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
Az eredménynaplókhoz is létrehozok egy artefaktum mintát.
{{< gallery match="images/4/*.png" >}}

## Készen állunk!
Most már tudom végezni a munkámat. Miután megváltoztattam az időkorlátokat, a teszt is "zöld".
{{< gallery match="images/5/*.png" >}}