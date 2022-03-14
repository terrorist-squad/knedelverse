+++
date = "2021-03-07"
title = "Instale o ESXi em um NUC. Preparar pen drive via MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.pt.md"
+++
Com o ESXi, o "intel NUC" pode ser dividido em qualquer número de computadores. Neste tutorial, eu mostro como instalei o VMware ESXi no meu NUC.Small preface: Recomendo uma atualização da BIOS antes da instalação do ESXi. Você também vai precisar de uma pen drive de 32GB. Eu comprei um pacote inteiro por menos de 5 euros cada da Amazon.
{{< gallery match="images/1/*.jpg" >}}
O meu NUC-8I7BEH tem 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 módulo e um disco rígido WD-RED de 2.5 polegadas de 1TB.
{{< gallery match="images/2/*.jpg" >}}

## Passo 1: Encontrar USB - Stick
O seguinte comando mostra-me todos os discos:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Aqui você pode ver que meu pen drive tem o identificador "disk2":
{{< gallery match="images/3/*.png" >}}

## Passo 2: Preparar sistema de arquivo
Agora eu posso usar o seguinte comando para preparar o sistema de arquivos:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Depois disso, eu também vejo o identificador no Finder:
{{< gallery match="images/4/*.png" >}}

## Passo 3: Ejectar a pen USB
Eu uso o comando "unmountDisk" para ejetar o volume:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Veja:
{{< gallery match="images/5/*.png" >}}

## Passo 4: Faça com que o stick seja inicializável
Agora digitamos o comando "sudo fdisk -e /dev/disk2" e depois digitamos "f 1", "write" e "quit", veja:
{{< gallery match="images/6/*.png" >}}

## Passo 5: Copiar dados
Agora eu tenho que baixar o ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Depois disso, posso montar o ESXi-ISO e copiar o conteúdo para o meu dispositivo USB.
{{< gallery match="images/7/*.png" >}}
Quando tudo é copiado, procuro o ficheiro "ISOLINUX.CFG" e renomeio-o para "SYSLINUX.CFG". Eu também acrescento "-p 1" à linha "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Agora o pau é utilizável. Divirta-se!
{{< gallery match="images/9/*.png" >}}