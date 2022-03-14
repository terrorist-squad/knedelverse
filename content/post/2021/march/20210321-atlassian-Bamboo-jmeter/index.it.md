+++
date = "2021-03-21"
title = "Cose interessanti con Atlassian: usare Bamboo e jMeter senza plugin"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.it.md"
+++
Oggi sto creando un test jMeter in Bamboo. Naturalmente, puoi anche implementare questa configurazione di test con i runner di Gitlab o gli slave di Jenkins.
## Passo 1: creare il test jMeter
Prima, naturalmente, dovete creare un test jMeter. Ho scaricato jMeter dal seguente url https://jmeter.apache.org/ e l'ho avviato con questo comando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Vedi: Il mio test dimostrativo per questo tutorial è destinato a contenere campionatori difettosi e funzionanti. Ho impostato i timeout molto bassi di proposito.
{{< gallery match="images/2/*.png" >}}
Salvo con il file JMX per il mio compito di Bamboo.
## Passo 2: Preparare l'agente di bambù
Poiché Java è il prerequisito per gli agenti Bamboo, installo Python solo dopo.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Creo un nuovo lavoro e un compito della shell.
{{< gallery match="images/3/*.png" >}}
E inserire questo script di shell:
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
La directory degli strumenti è fissa sulla macchina e non fa parte del repository del progetto. Inoltre, uso questo script Python:
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
Creo anche un modello di artefatto per i log dei risultati.
{{< gallery match="images/4/*.png" >}}

## Pronti!
Ora posso fare il mio lavoro. Dopo aver cambiato i timeout, il test è anche "verde".
{{< gallery match="images/5/*.png" >}}