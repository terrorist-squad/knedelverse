+++
date = "2021-03-21"
title = "Coola saker med Atlassian: att använda Bamboo och jMeter utan plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.sv.md"
+++
Idag skapar jag ett jMeter-test i Bamboo. Naturligtvis kan du också implementera denna testuppsättning med Gitlab-runners eller Jenkins-slavar.
## Steg 1: Skapa ett jMeter-test
Först måste du förstås skapa ett jMeter-test. Jag laddade ner jMeter från följande webbadress https://jmeter.apache.org/ och startade det med följande kommando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Se:Mitt demotest för den här handledningen är tänkt att innehålla både felaktiga och fungerande samplare. Jag ställde in tidsgränserna mycket lågt med flit.
{{< gallery match="images/2/*.png" >}}
Jag sparar JMX-filen för min Bamboo-uppgift.
## Steg 2: Förbered Bamboo Agent
Eftersom Java är en förutsättning för Bamboo-agenter installerar jag Python först därefter.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Jag skapar ett nytt jobb och en skaluppgift.
{{< gallery match="images/3/*.png" >}}
Lägg in det här skalskriptet:
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
Verktygskatalogen är fixerad på maskinen och är inte en del av projektregistret. Dessutom använder jag det här Python-skriptet:
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
Jag skapar också ett artefaktmönster för resultatprotokollen.
{{< gallery match="images/4/*.png" >}}

## Redo!
Nu kan jag göra mitt jobb. Efter att jag ändrade tidsgränserna är testet också "grönt".
{{< gallery match="images/5/*.png" >}}
