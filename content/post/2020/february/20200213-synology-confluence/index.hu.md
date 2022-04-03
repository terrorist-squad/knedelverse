+++
date = "2020-02-13"
title = "Synology-Nas: Confluence mint wiki rendszer"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.hu.md"
+++
Ha az Atlassian Confluence-t szeretné telepíteni egy Synology NAS-ra, akkor a legjobb helyen jár.
## 1. lépés
Először megnyitom a Docker alkalmazást a Synology felületen, majd a "Regisztráció" almenüpontra megyek. Ott rákeresek a "Confluence" kifejezésre, és az első képen rákattintok az "Atlassian Confluence"-re.
{{< gallery match="images/1/*.png" >}}

## 2. lépés
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## Automatikus újraindítás
Duplán kattintok a Confluence-képemre.
{{< gallery match="images/2/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/3/*.png" >}}

## Kikötők
A Confluence konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a Confluence egy újraindítás után más porton fut.
{{< gallery match="images/4/*.png" >}}

## Memória
Létrehozok egy fizikai mappát, és csatlakoztatom a konténerbe (/var/atlassian/application-data/confluence/). Ez a beállítás megkönnyíti az adatok biztonsági mentését és visszaállítását.
{{< gallery match="images/5/*.png" >}}
Ezek után a beállítások után a Confluence elindítható!
{{< gallery match="images/6/*.png" >}}
