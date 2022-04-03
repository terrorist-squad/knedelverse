+++
date = "2019-07-17"
title = "PIFM：FMラジオで104.6ワールドワイド"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.ja.md"
+++
104.6RTLのファンで、ベルリンのヒットラジオを聴かない日はないと思っているならば、あなたは正しい場所にいます。ラズパイと呼ばれるシングルボードコンピュータと、アンテナとしてGPIOポート4のケーブルが必要です。
## 以下のパッケージが必要です。

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
ダウンロードフォルダを作り、PIFMスクリプトをダウンロードする。
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## ピフムスクリプト
次のような内容のファイル "$vim /home/pi/radio-streamer.sh" を新規に作成します。
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
このスクリプトには、以下の権限が必要です。
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## 可能なcrontjob
毎晩4時から5時の間にコンピュータを再起動する。また、Radionは1時間ごとに再接続を行います。
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```
