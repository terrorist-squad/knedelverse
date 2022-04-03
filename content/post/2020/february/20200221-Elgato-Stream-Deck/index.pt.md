+++
date = "2020-02-07"
title = "Pequeno conto: Roteiros de Bash com Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.pt.md"
+++
Se você quiser incluir um roteiro de bash no Elgato Stream Deck, primeiro você precisa de um roteiro de bash.
## Passo 1: Criar script Bash:
Eu crio um arquivo chamado "say-hallo.sh" com o seguinte conteúdo:
```
#!/bin/bash
say "hallo"

```

## Passo 2: Definir direitos
O seguinte comando torna o arquivo executável:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Passo 3: Incluir o roteiro do Bash no baralho
3.1) Agora a aplicação Stream Deck pode ser aberta:
{{< gallery match="images/1/*.png" >}}
3.2) Depois arrasto a acção "Open System" (Abrir Sistema) para um botão.
{{< gallery match="images/2/*.png" >}}
3.3) Agora eu posso escolher meu roteiro de bash:
{{< gallery match="images/3/*.png" >}}

## Passo 4: Feito!
O novo botão é agora utilizável.
