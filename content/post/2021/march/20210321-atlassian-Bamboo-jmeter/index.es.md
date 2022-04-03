+++
date = "2021-03-21"
title = "Cosas chulas con Atlassian: usar Bamboo y jMeter sin plugins"
difficulty = "level-2"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-Bamboo-jmeter/index.es.md"
+++
Hoy estoy creando una prueba de jMeter en Bamboo. Por supuesto, también puedes implementar esta configuración de prueba con corredores de Gitlab o esclavos de Jenkins.
## Paso 1: Crear la prueba jMeter
Primero, por supuesto, hay que crear una prueba jMeter. Descargué jMeter de la siguiente url https://jmeter.apache.org/ y lo inicié con este comando:
{{< terminal >}}
java -jar bin/ApacheJMeter.jar

{{</ terminal >}}
Ver:Mi prueba de demostración para este tutorial está destinada a contener muestreadores defectuosos y que funcionan. Puse los tiempos de espera muy bajos a propósito.
{{< gallery match="images/2/*.png" >}}
Guardo con el archivo JMX para mi tarea de Bamboo.
## Paso 2: Preparar el agente de bambú
Como Java es el requisito previo para los agentes de Bamboo, sólo instalo Python después.
{{< terminal >}}
apt-get update
apt-get install python

{{</ terminal >}}
Creo un nuevo trabajo y una tarea de shell.
{{< gallery match="images/3/*.png" >}}
E inserta este script de shell:
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
El directorio de herramientas está fijado en la máquina y no forma parte del repositorio del proyecto. Además, utilizo este script de Python:
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
También creo un patrón de artefactos para los registros de resultados.
{{< gallery match="images/4/*.png" >}}

## ¡Listo!
Ahora puedo hacer mi trabajo. Después de cambiar los tiempos de espera, la prueba también es "verde".
{{< gallery match="images/5/*.png" >}}
