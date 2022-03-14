+++
date = "2021-03-21"
title = "Coisas legais com Atlassian: usando Bamboo e jMeter sem plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.pt.md"
+++
Hoje estou a criar um teste de jMeter em Bamboo. É claro, você também pode implementar esta configuração de teste com corredores Gitlab ou escravos Jenkins.
## Passo 1: Criar teste jMeter
Primeiro, é claro, você tem que criar um teste de jMeter. Eu baixei o jMeter da seguinte url https://jmeter.apache.org/ e o iniciei com este comando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Veja:O meu teste demo para este tutorial destina-se a conter amostras defeituosas e funcionais. Eu estabeleci os intervalos de tempo muito baixos de propósito.
{{< gallery match="images/2/*.png" >}}
Eu guardo com o ficheiro JMX para a minha tarefa Bamboo.
## Passo 2: Preparar o Agente Bamboo
Como Java é o pré-requisito para agentes Bamboo, eu só instalo o Python depois.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Eu crio um novo trabalho e uma tarefa de shell.
{{< gallery match="images/3/*.png" >}}
E insira este roteiro da concha:
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
O diretório de ferramentas é fixado na máquina e não faz parte do repositório do projeto. Além disso, eu uso este guião Python:
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
Eu também crio um padrão de artefacto para os registos de resultados.
{{< gallery match="images/4/*.png" >}}

## Pronto!
Agora eu posso fazer o meu trabalho. Depois de ter mudado os intervalos de tempo, o teste também é "verde".
{{< gallery match="images/5/*.png" >}}