+++
date = "2020-02-07"
title = "Short story: Bash scripts with Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.en.md"
+++
If you want to include a bash script in the Elgato stream deck, you first need a bash script.
## Step 1: Create Bash script:
I create a file named "say-hallo.sh" with the following content:
```
#!/bin/bash
say "hallo"

```

## Step 2: Set rights
The following command makes the file executable:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Step 3: Include bash script in the deck
3.1) Now the Stream Deck app can be opened:
{{< gallery match="images/1/*.png" >}}
3.2) Afterwards I drag the "System:open" - action to a button
{{< gallery match="images/2/*.png" >}}
3.3) Now I can choose my bash script:
{{< gallery match="images/3/*.png" >}}

## Step 4: Ready!
