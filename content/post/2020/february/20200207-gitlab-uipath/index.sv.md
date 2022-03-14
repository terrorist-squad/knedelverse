+++
date = "2020-02-07"
title = "Orkestrera uiPath Windows-robotar med Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.sv.md"
+++
UiPath är en etablerad standard inom robotiserad processautomatisering. Med uiPath kan du utveckla en mjukvarubaserad robot/robot som tar hand om komplex databehandling eller klickuppgifter åt dig. Men kan en sådan robot också styras med Gitlab?Det korta svaret är "ja". Hur det går till kan du se här. För följande steg behöver du administratörsrättigheter och viss erfarenhet av uiPath, Windows och Gitlab.
## Steg 1: Det första du gör är att installera en Gitlab runner.
1.1.) Skapa en ny Gitlab-användare för ditt måloperativsystem. Klicka på "Inställningar" > "Familj och andra användare" och sedan på "Lägg till en annan person på den här datorn".
{{< gallery match="images/1/*.png" >}}
1.2.) Klicka på "Jag känner inte till den här personens autentiseringsuppgifter" och sedan på "Lägg till användare utan Microsoft-konto" för att skapa en lokal användare.
{{< gallery match="images/2/*.png" >}}
1.3.) I följande dialogruta kan du fritt välja användarnamn och lösenord:
{{< gallery match="images/3/*.png" >}}

## Steg 2: Aktivera inloggning för tjänsten
Om du vill använda en separat, lokal användare för din Windows Gitlab Runner måste du "Aktivera inloggning som tjänst". Detta gör du genom att gå till Windows-menyn > "Lokal säkerhetsprincip". Där väljer du "Local Policy" > "Assign User Rights" på vänster sida och "Logon as Service" på höger sida.
{{< gallery match="images/4/*.png" >}}
Lägg sedan till den nya användaren.
{{< gallery match="images/5/*.png" >}}

## Steg 3: Registrera Gitlab Runner
Windows-installationsprogrammet för Gitlab Runner finns på följande sida: https://docs.gitlab.com/runner/install/windows.html . Jag skapade en ny mapp på "C"-enheten och lade installationsprogrammet där.
{{< gallery match="images/6/*.png" >}}
3.1.) Jag använder kommandot "CMD" som "Administratör" för att öppna en ny konsol och byta till en katalog "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Där kallar jag följande kommando. Som du kan se anger jag också Gitlab-användarens användarnamn och lösenord här.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Nu kan Gitlab Runner registreras. Om du använder ett självsignerat certifikat för din Gitlab-installation måste du ange certifikatet med attributet "-tls-ca-file=". Ange sedan Gitlabs webbadress och registertoken.
{{< gallery match="images/8/*.png" >}}
3.2.) När registreringen har lyckats kan Runner startas med kommandot "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Bra! Din Gitlab Runner är igång och kan användas.
{{< gallery match="images/10/*.png" >}}

## Steg 4: Installera Git
Eftersom en Gitlab runner arbetar med Git-versionering måste Git för Windows också installeras:
{{< gallery match="images/11/*.png" >}}

## Steg 5: Installera UiPath
UiPath-installationen är den enklaste delen av den här handledningen. Logga in som Gitlab-användare och installera community-utgåvan. Naturligtvis kan du installera all programvara som din robot behöver direkt, till exempel Office 365.
{{< gallery match="images/12/*.png" >}}

## Steg 6: Skapa Gitlab-projekt och pipeline
Nu kommer den stora finalen av denna handledning. Jag skapar ett nytt Gitlab-projekt och kontrollerar mina uiPath-projektfiler.
{{< gallery match="images/13/*.png" >}}
6.1.) Dessutom skapar jag en ny fil ".gitlab-ci.yml" med följande innehåll:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Min Windows-programvarurobot körs direkt efter att den har lagts in i mastergrenen:
{{< gallery match="images/14/*.png" >}}
