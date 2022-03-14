+++
date = "2021-03-18"
title = "Σύντομη ιστορία: Προσαρμογή ξένων βιβλιοθηκών Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.el.md"
+++
Τις προάλλες ήθελα να προσαρμόσω μεθόδους σε μια ξένη βιβλιοθήκη Java και γι' αυτό έψαχνα για ένα κατάλληλο εργαλείο. Κοίταξα πολύ τους συντάκτες bytecode και τον bytecode. Αλλά τελικά κατέληξα στο Recaf και είμαι απόλυτα ενθουσιασμένη: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Το εργαλείο βρίσκεται στην ακόλουθη διεύθυνση: https://github.com/Col-E/Recaf/releases. Η απομεταγλώττιση, η επαναμεταγλώττιση και ο χειρισμός βιβλιοθηκών είναι παιχνιδάκι με το Recaf! Είναι καλύτερο να το δοκιμάσετε αμέσως.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
