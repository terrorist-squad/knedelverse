+++
date = "2021-04-11"
title = "Rövid történet: Synology kötetek csatlakoztatása az ESXi-hez."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.hu.md"
+++

## 1. lépés: Az "NFS" szolgáltatás aktiválása
Először is aktiválni kell az "NFS" szolgáltatást a lemezállomáson. Ehhez a "Vezérlőpult" > "Fájlszolgáltatások" beállításra megyek, és az "NFS engedélyezése" gombra kattintok.
{{< gallery match="images/1/*.png" >}}
Ezután a "Megosztott mappa" gombra kattintok, és kiválasztok egy könyvtárat.
{{< gallery match="images/2/*.png" >}}

## 2. lépés: Könyvtárak csatlakoztatása az ESXi-ben
Az ESXi-ben a "Storage" > "New datastore" menüpontra kattintok, és ott megadom az adataimat.
{{< gallery match="images/3/*.png" >}}

## Kész
Most már használható a memória.
{{< gallery match="images/4/*.png" >}}
A teszteléshez telepítettem egy DOS telepítést és egy régi könyvelési szoftvert ezen a csatlakozási ponton keresztül.
{{< gallery match="images/5/*.png" >}}

