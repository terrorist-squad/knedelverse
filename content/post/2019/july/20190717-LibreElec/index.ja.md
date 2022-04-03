+++
date = "2019-07-17"
title = "RaspberryPiZeroWとLibreElecによるSmartTV。"
difficulty = "level-3"
tags = ["diy", "diy-smart-tv", "libreelec", "linux", "mediacenter", "mediapc", "raspberry", "raspberry-pi", "smartv"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-LibreElec/index.ja.md"
+++
SmartTVは時限爆弾になりかねません。テレビのオペレーティングシステムには重大な欠陥があったり、最新の状態に保たれていないことがよくあります。良い解決策は、スタンドアロンのMediaPCオペレーティングシステムにすることができます。LibreElecは最弱のRaspberryで動作し、テレビのリモコンで操作することが可能です。LibreElecはSmartTvのOSよりもカスタマイズ性が高く、様々なアプリ/モジュールが提供されています。必要なものは、RaspberryZeroWと空のSDカードだけです。
## ステップ1．
Noobsのインストーラは、https://www.raspberrypi.org/downloads/noobs/ からダウンロードしてください。
## ステップ2．
空のSDカードにこのZIPアーカイブを解凍してください。
"{{< gallery match="images/1/*.png" >}}"
完了！これで、RaspberryPiZeroとテレビを接続することができました。その後、インストールメニューが表示されます。
"{{< gallery match="images/2/*.jpg" >}}"
ここで「LibreElec RPI」を選択し、「インストール」をクリックしてください。
"{{< gallery match="images/3/*.jpg" >}}"
その後、インストールが終了し、ブート可能になります
"{{< gallery match="images/4/*.jpg" >}}"
これで、このMediaPcをNASなどの外部ソースに接続したり、Youtubeなどのアプリをインストールすることができるようになりました。楽しんできてください。   
"{{< gallery match="images/5/*.jpg" >}}"
すでに書いたように、CECコントローラー経由でテレビのリモコンを使うことも可能です。
