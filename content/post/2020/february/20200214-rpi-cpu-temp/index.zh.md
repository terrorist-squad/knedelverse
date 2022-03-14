+++
date = "2020-02-14"
title = "树莓派：PI CPU的无热性"
difficulty = "level-3"
tags = ["bash", "cpu", "cron", "linux", "maker", "raspberry", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-rpi-cpu-temp/index.zh.md"
+++

{{< gallery match="images/1/*.jpg" >}}
如果你想在某个温度下关闭树莓，那么你就来对地方了。我有一个脚本，通过Crontab检查CPU温度。
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
该脚本需要以下权限。
{{< terminal >}}
chmod 775 /usr/local/bin/checkTemp.sh

{{</ terminal >}}
可能的crontab条目。
```
*/5 * * * * /usr/bin/sudo -H /usr/local/bin/checkTemp.sh >> /dev/null 2>&1

```