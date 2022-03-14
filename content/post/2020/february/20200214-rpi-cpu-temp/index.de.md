+++
date = "2020-02-14"
title = "Raspberry-PI: Hitzefrei für die PI-CPU"
difficulty = "level-3"
tags = ["bash", "cpu", "cron", "linux", "maker", "raspberry", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-rpi-cpu-temp/index.de.md"
+++

{{< gallery match="images/1/*.jpg" >}}

Wenn Sie einen Raspberry ab einer bestimmten Temperatur abschalten wollen, dann sind Sie hier richtig. Ich habe ein Script, dass per Crontab die CPU-Temperatur prüft:
```
#!/bin/sh
#  This script reads the Broadcom SoC temperature value and shuts down if it
#  exceeds a particular value.
#  80ºC is the maximum allowed for a Raspberry Pi.


# Get the reading from the sensor and strip the non-number parts
SENSOR="`/opt/vc/bin/vcgencmd measure_temp | cut -d "=" -f2 | cut -d "'" -f1`"

# -gt only deals with whole numbers, so round it.
TEMP="`/usr/bin/printf "%.0f\n" ${SENSOR}`"

# How hot will we allow the SoC to get?
MAX="78"

if [ "${TEMP}" -gt "${MAX}" ] ; then

 # This will be mailed to root if called from cron
 echo "${TEMP}ºC is too hot!"

 # Send a message to syslog
 /usr/bin/logger "Shutting down due to SoC temp ${TEMP}."

 # Halt the box
 /sbin/shutdown -h now
else
  echo "${TEMP}ºC ok!"
  exit 0
fi
```

Das Script braucht die folgenden Rechte:
{{< terminal >}}
chmod 775 /usr/local/bin/checkTemp.sh
{{</ terminal >}}

Möglicher Crontab-Eintrag:
```
*/5 * * * * /usr/bin/sudo -H /usr/local/bin/checkTemp.sh >> /dev/null 2>&1
```