+++
date = "2020-02-07"
title = "Orchestrare uiPath Windows Robots con Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.it.md"
+++
UiPath è uno standard affermato nell'automazione dei processi robotici. Con uiPath, è possibile sviluppare un robot/robot basato su software che si occupa di complesse elaborazioni di dati o compiti di clic al posto vostro. Ma un tale robot può anche essere controllato con Gitlab? La risposta breve è "sì". E come esattamente si può vedere qui. Per i seguenti passi, avete bisogno di diritti di amministrazione e un po' di esperienza con uiPath, Windows e Gitlab.
## Passo 1: La prima cosa da fare è installare un runner Gitlab.
1.1.) Crea un nuovo utente Gitlab per il tuo sistema operativo di destinazione. Clicca su "Impostazioni" > "Famiglia e altri utenti" e poi su "Aggiungi un'altra persona a questo PC".
{{< gallery match="images/1/*.png" >}}
1.2.) Cliccate su "Non conosco le credenziali di questa persona" e poi su "Aggiungi utente senza account Microsoft" per creare un utente locale.
{{< gallery match="images/2/*.png" >}}
1.3.) Nel seguente dialogo potete selezionare liberamente il nome utente e la password:
{{< gallery match="images/3/*.png" >}}

## Passo 2: attivare l'accesso al servizio
Se vuoi usare un utente locale separato per il tuo Windows Gitlab Runner, allora devi "Activate logon as a service". Per farlo, andate nel menu di Windows > "Criteri di sicurezza locali". Lì, seleziona "Criteri locali" > "Assegnazione diritti utente" sul lato sinistro e "Accesso come servizio" sul lato destro.
{{< gallery match="images/4/*.png" >}}
Poi aggiungi il nuovo utente.
{{< gallery match="images/5/*.png" >}}

## Passo 3: registrare Gitlab Runner
Il programma di installazione per Windows per il Gitlab Runner può essere trovato alla seguente pagina: https://docs.gitlab.com/runner/install/windows.html . Ho creato una nuova cartella nell'unità "C" e ci ho messo il programma di installazione.
{{< gallery match="images/6/*.png" >}}
3.1.) Uso il comando "CMD" come "Amministratore" per aprire una nuova console e passare a una directory "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Lì chiamo il seguente comando. Come puoi vedere, inserisco qui anche il nome utente e la password dell'utente Gitlab.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Ora il runner di Gitlab può essere registrato. Se usi un certificato autofirmato per la tua installazione di Gitlab, devi fornire il certificato con l'attributo "-tls-ca-file=". Poi inserisci l'url di Gitlab e il token di registro.
{{< gallery match="images/8/*.png" >}}
3.2.) Dopo l'avvenuta registrazione, il corridore può essere avviato con il comando "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Grande! Il tuo Gitlab Runner è attivo, funzionante e utilizzabile.
{{< gallery match="images/10/*.png" >}}

## Passo 4: installare Git
Poiché un runner Gitlab lavora con il versioning Git, deve essere installato anche Git per Windows:
{{< gallery match="images/11/*.png" >}}

## Passo 5: installare UiPath
L'installazione di UiPath è la parte più semplice di questo tutorial. Accedi come utente di Gitlab e installa l'edizione comunitaria. Naturalmente, puoi installare subito tutto il software di cui il tuo robot ha bisogno, per esempio: Office 365.
{{< gallery match="images/12/*.png" >}}

## Passo 6: creare il progetto Gitlab e la pipeline
Ora arriva il gran finale di questo tutorial. Creo un nuovo progetto Gitlab e controllo i miei file di progetto uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Inoltre, creo un nuovo file ".gitlab-ci.yml" con il seguente contenuto:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Il mio robot software Windows viene eseguito direttamente dopo il commit sul ramo master:
{{< gallery match="images/14/*.png" >}}
