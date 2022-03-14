+++
date = "2019-07-17"
title = "RaspberryPiZeroWとLibreElecによるSmartTV"
difficulty = "level-3"
tags = ["diy", "diy-smart-tv", "libreelec", "linux", "mediacenter", "mediapc", "raspberry", "raspberry-pi", "smartv"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-LibreElec/index.ja.md"
+++
SmartTVは時限爆弾のようなものです。テレビのOSには重大な欠陥があったり、最新の状態に保たれていないことがよくあります。良い解決策は、スタンドアローンのMediaPCオペレーティング・システムです。LibreElecは最も弱いRaspberryで動作し、テレビのリモコンで操作することができます。LibreElecは、SmartTvのOSよりもカスタマイズ性が高く、様々なアプリ/モジュールを提供しています。必要なのは、RaspberryZeroWと空のSDカードだけです。
## Step 1:
https://www.raspberrypi.org/downloads/noobs/ から Noobs のインストーラーをダウンロードします。
## Step 2:
このZIPアーカイブを空のSDカードに解凍します。
"{{< gallery match="images/1/*.png" >}}"
できました。これで、RaspberryPiZeroをテレビに接続することができます。すると、インストールメニューが表示されます。
"{{< gallery match="images/2/*.jpg" >}}"
ここで「LibreElec RPI」を選択し、「インストール」をクリックしてください。
"{{< gallery match="images/3/*.jpg" >}}"
その後、インストールが完了し、起動可能な状態になります。
"{{< gallery match="images/4/*.jpg" >}}"
これで、このMediaPcをNASなどの外部ソースに接続したり、Youtubeなどのアプリをインストールすることができます。楽しんでください。   
"{{< gallery match="images/5/*.jpg" >}}"
