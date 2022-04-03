+++
date = "2021-03-18"
title = "Lyhyt tarina: Ulkomaisten Java-kirjastojen mukauttaminen"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.fi.md"
+++
Eräänä päivänä halusin mukauttaa vieraan Java-kirjaston metodeja ja etsin siksi sopivaa työkalua. Tutkin paljon bytecode-editoreita ja bytecodea. Mutta lopulta päädyin Recafiin ja olen aivan innoissani: https://github.com/Col-E/Recaf.
{{< gallery match="images/1/*.png" >}}
Työkalu löytyy seuraavasta osoitteesta: https://github.com/Col-E/Recaf/releases. Kirjastojen dekompilointi, uudelleenkompilointi ja manipulointi on lastenleikkiä Recafin kanssa! On parasta kokeilla sitä heti.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

