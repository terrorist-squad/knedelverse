+++
date = "2020-02-07"
title = "短編：Elgato Stream Deckを使ったBashスクリプト"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.ja.md"
+++
Elgato Stream Deckにbashスクリプトを組み込む場合、まずbashスクリプトが必要です。
## ステップ1：Bashスクリプトを作成する。
以下の内容で「say-hallo.sh」というファイルを作成します。
```
#!/bin/bash
say "hallo"

```

## ステップ2：権利の設定
次のコマンドは、そのファイルを実行可能にするものです。
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## ステップ3：Bashスクリプトをデッキに組み込む
3.1) これで、Stream Deckアプリを開くことができます。
{{< gallery match="images/1/*.png" >}}
3.2) 次に、「Open System」アクションをボタンにドラッグします。
{{< gallery match="images/2/*.png" >}}
3.3) これで、bashスクリプトを選択できるようになりました。
{{< gallery match="images/3/*.png" >}}

## ステップ4：完了
新しいボタンが使えるようになりました。
