+++
date = "2020-02-07"
title = "ショートストーリー：Elgato Stream Deckを使ったBashスクリプト"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.ja.md"
+++
Elgato Stream Deckにbashスクリプトを入れたい場合は、まずbashスクリプトが必要です。
## ステップ1：Bashスクリプトの作成
次のような内容の「say-hallo.sh」というファイルを作ります。
```
#!/bin/bash
say "hallo"

```

## ステップ2：権利の設定
次のコマンドは、ファイルを実行可能な状態にします。
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## ステップ3：Bashスクリプトをデッキに入れる
3.1) これで、「Stream Deck」アプリを開くことができます。
{{< gallery match="images/1/*.png" >}}
3.2) 次に、"Open System "アクションをボタンにドラッグします。
{{< gallery match="images/2/*.png" >}}
3.3) これで、bashスクリプトを選択できるようになりました。
{{< gallery match="images/3/*.png" >}}

## ステップ4: 完了
