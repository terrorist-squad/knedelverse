+++
date = "2021-04-04"
title = "Σύντομη ιστορία: Έλεγχος επιφάνειας εργασίας με xDoTools και xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.el.md"
+++
Σε αυτό το σεμινάριο δείχνω πώς να ελέγχετε μια επιφάνεια εργασίας Linux - μέσω του Bash. Τα ακόλουθα πακέτα είναι απαραίτητα για το ρομπότ Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Μετά από αυτό μπορείτε να χρησιμοποιήσετε όλες τις εντολές του xdotool, για παράδειγμα:
```
#!/bin/bash

#mouse bewegen
xdotool mousemove 100 200 

#Mouse - Koordinaten erfassen
xdotool getmouselocation 

#Mouse-klick
xdotool click 1 

Mouse-Klick auf Koordinaten
xdotool mousemove 100 200 click 1 

#usw...

```
Στο ακόλουθο παράδειγμα, γίνεται αναζήτηση στο παράθυρο του Firefox και ανοίγει μια νέα καρτέλα με τη διεύθυνση Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Γιατί χρειάζεστε xclip????
Με το xdotools/"ctrl c" μπορείτε να αντιγράψετε τα περιεχόμενα στην κρυφή μνήμη και να τα διαβάσετε ή να τα επεξεργαστείτε με το xclip στο σενάριο bash.
