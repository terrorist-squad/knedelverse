+++
date = "2021-03-21"
title = "Skvělé věci s Atlassianem: používání Bamboo a jMeteru bez zásuvných modulů"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.cs.md"
+++
Dnes vytvářím test jMeter v aplikaci Bamboo. Toto testovací nastavení můžete samozřejmě realizovat také pomocí běhounů Gitlab nebo otroků Jenkins.
## Krok 1: Vytvoření testu jMeter
Nejprve je samozřejmě nutné vytvořit test jMeter. Stáhl jsem si jMeter z následující adresy https://jmeter.apache.org/ a spustil ho tímto příkazem:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Viz:Můj ukázkový test pro tento návod má obsahovat vadné a funkční vzorkovače. Záměrně jsem nastavil velmi nízké časové limity.
{{< gallery match="images/2/*.png" >}}
Ukládám pomocí souboru JMX pro svou úlohu Bamboo.
## Krok 2: Příprava bambusového prostředku
Protože Java je podmínkou pro agenty Bamboo, nainstaluji Python až poté.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Vytvořím novou úlohu a úlohu shellu.
{{< gallery match="images/3/*.png" >}}
A vložte tento shell skript:
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
Adresář s nástroji je pevně umístěn v počítači a není součástí úložiště projektu. Kromě toho používám tento skript Pythonu:
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
Vytvářím také vzor artefaktu pro protokoly výsledků.
{{< gallery match="images/4/*.png" >}}

## Připraveno!
Nyní mohu dělat svou práci. Po změně časových limitů je test také "zelený".
{{< gallery match="images/5/*.png" >}}