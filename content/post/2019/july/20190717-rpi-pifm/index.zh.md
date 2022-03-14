+++
date = "2019-07-17"
title = "PIFM：104.6全球调频电台"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.zh.md"
+++
如果你是104.6 RTL的粉丝，不想一天都没有柏林的热门电台，那么你就来对地方了。你需要一台名为树莓的单板计算机，以及GPIO端口4上的一根电缆作为天线。
## 需要以下软件包

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
我创建一个下载文件夹并下载PIFM脚本。
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm脚本
我创建了一个新文件"$vim /home/pi/radio-streamer.sh"，内容如下。
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
该脚本需要以下权限。
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## 可能的crontjob
每天晚上4点到5点之间都会重新启动电脑。此外，Radion每小时都会重新连接。
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```