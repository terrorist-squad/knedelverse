+++
date = "2021-03-21"
title = "Cooles mit Atlassian: Bamboo und jMeter ohne Plugins nutzen"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.de.md"
+++

Heute erstelle ich einen jMeter-Test in Bamboo. Natürlich kann man dieses Test-Setup auch mit Gitlab-Runners oder Jenkins-Slaves umsetzen.

## Schritt 1: jMeter-Test erstellen
Als erstes muss man natürlich einen jMeter-Test erstellen. Ich habe jMeter unter der folgenden Url heruntergeladen https://jmeter.apache.org/ und mit diesem Befehl gestartet:

{{< terminal >}}
java -jar bin/ApacheJMeter.jar
{{</ terminal >}}

Siehe:
Mein Demo-Test für dieses Tutorial soll fehlerhafte und funktionierende Sampler enthalten. Ich setze die Timeouts mit Absicht sehr gering an.
{{< gallery match="images/2/*.png" >}}

Ich speichere mit die JMX-Datei für meine Bamboo-Task.

## Schritt 2: Bamboo-Agent vorbereiten
Da Java die Voraussetzung für Bamboo-Agents ist, installiere ich nur Python nach.
{{< terminal >}}
apt-get update
apt-get install python
{{</ terminal >}}

Ich erstelle einen neuen Job und eine Shell-Task.
{{< gallery match="images/3/*.png" >}}

Und füge dieses Shell-Script ein:
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

Das Tool-Verzeichnis ist fest auf der Maschine und nicht Teil des Projekt-Repositorys. Zusätzlich nutze ich dieses Python-Skript:
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

Außerdem lege ich ein Artefakt-Muster für die Ergebnis-Logs an.
{{< gallery match="images/4/*.png" >}}

## Fertig!
Nun kann ich meinen Job ausführen. Nachdem ich die Timeouts geändert habe, ist auch der Test „grün“.
{{< gallery match="images/5/*.png" >}}