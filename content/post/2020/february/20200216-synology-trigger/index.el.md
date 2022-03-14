+++
date = "2020-02-16"
title = "Synology-Nas: Ρύθμιση των εναυσμάτων του Gitlab"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "Synology", "trigger"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200216-synology-trigger/index.en.md"
+++
Προκειμένου να ενεργοποιηθεί αυτόματα ένας αγωγός Gitlab, πρέπει να δημιουργηθεί ένα λεγόμενο trigger. Μπορείτε να δημιουργήσετε όσους πυροκροτητές θέλετε στις ρυθμίσεις του έργου.
{{< gallery match="images/1/*.png" >}}
Αυτά τα εναύσματα μοιάζουν ως εξής. Φυσικά, τα (placeholders) πρέπει να αντικατασταθούν.
{{< terminal >}}
curl -X POST -F token=(TOKEN) -F ref=(BRANCH) http://(ip):(port)/api/v4/projects/(project-id)/trigger/pipeline
{{</terminal >}}

This curl call can be entered into the Synology task scheduler, Done!

{{< gallery match="images/1/*.png" >}}