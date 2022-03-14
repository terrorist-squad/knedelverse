+++
date = "2019-07-17"
title = "PIFM: 104.6 Worldwide on FM Radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.ja.md"
+++
もしあなたが104.6 RTLのファンで、ベルリンのヒットラジオなしでは一日も過ごしたくないと思っているなら、あなたは正しい場所にいるのです。Raspberryと呼ばれるシングルボードコンピュータと、アンテナとしてGPIOポート4にケーブルを用意します。
## 以下のパッケージが必要です。

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
ダウンロードフォルダを作り、PIFMスクリプトをダウンロードします。
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## PIFMスクリプト
以下の内容で「$vim /home/pi/radio-streamer.sh」というファイルを新たに作成します。
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
このスクリプトには以下の権限が必要です。
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## 可能なクーロンジョブ
コンピュータは毎晩4時から5時の間に再起動されます。また、「ラジオン」は1時間ごとに再接続します。
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```