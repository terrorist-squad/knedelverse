+++
date = "2020-02-07"
title = "Az uiPath Windows robotok archiválása a Gitlab segítségével"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-gitlab-uipath/index.hu.md"
+++
Az UiPath a robotizált folyamatautomatizálás bevett szabványa. Az uiPath segítségével olyan szoftveralapú robotot/robotot fejleszthet, amely komplex adatfeldolgozási vagy kattintási feladatokat végez el Ön helyett. De lehet-e egy ilyen robotot Gitlab segítségével is irányítani?A rövid válasz: igen. És hogy pontosan hogyan, azt itt láthatja. A következő lépésekhez rendszergazdai jogokra, valamint némi uiPath, Windows és Gitlab tapasztalatra van szükséged.
## 1. lépés: Az első teendő a Gitlab runner telepítése.
1.1.) Hozzon létre egy új Gitlab felhasználót a cél operációs rendszeréhez. Kattintson a "Beállítások" > "Család és más felhasználók", majd a "Más személy hozzáadása ehhez a számítógéphez" gombra.
{{< gallery match="images/1/*.png" >}}
1.2.) Kattintson a "Nem ismerem a személy hitelesítő adatait", majd a "Felhasználó hozzáadása Microsoft-fiók nélkül" gombra egy helyi felhasználó létrehozásához.
{{< gallery match="images/2/*.png" >}}
1.3.) A következő párbeszédablakban szabadon kiválaszthatja a felhasználónevet és a jelszót:
{{< gallery match="images/3/*.png" >}}

## 2. lépés: A szolgáltatás bejelentkezésének aktiválása
Ha külön helyi felhasználót szeretne használni a Windows Gitlab Runnerhez, akkor a "Bejelentkezés aktiválása szolgáltatásként" opciót kell választania. Ehhez lépjen a Windows menü > "Helyi biztonsági házirend" menüpontjába. Ott válassza a "Helyi házirend" > "Felhasználói jogok hozzárendelése" menüpontot a bal oldalon, majd a "Bejelentkezés szolgáltatásként" menüpontot a jobb oldalon.
{{< gallery match="images/4/*.png" >}}
Ezután adja hozzá az új felhasználót.
{{< gallery match="images/5/*.png" >}}

## 3. lépés: Gitlab Runner regisztrálása
A Gitlab Runner Windows telepítője a következő oldalon található: https://docs.gitlab.com/runner/install/windows.html . Létrehoztam egy új mappát a "C" meghajtón, és oda tettem a telepítőt.
{{< gallery match="images/6/*.png" >}}
3.1.) A "CMD" parancsot használom "Rendszergazdaként" egy új konzol megnyitásához és a "cd C:\gitlab-runner" könyvtárba való váltáshoz.
{{< gallery match="images/7/*.png" >}}
Ott a következő parancsot hívom. Mint látható, itt adom meg a Gitlab felhasználó felhasználónevét és jelszavát is.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Most már regisztrálható a Gitlab runner. Ha önaláírt tanúsítványt használ a Gitlab telepítéséhez, akkor a tanúsítványt a "-tls-ca-file=" attribútummal kell megadni. Ezután adja meg a Gitlab url-t és a regisztrációs tokent.
{{< gallery match="images/8/*.png" >}}
3.2.) Sikeres regisztráció után a futó a "gitlab-runner-windows-386.exe start" paranccsal indítható:
{{< gallery match="images/9/*.png" >}}
Nagyszerű! A Gitlab Runner már működik és használható.
{{< gallery match="images/10/*.png" >}}

## 4. lépés: Git telepítése
Mivel a Gitlab futtató a Git verziókezelésével működik, a Git for Windows-t is telepíteni kell:
{{< gallery match="images/11/*.png" >}}

## 5. lépés: Az UiPath telepítése
Az UiPath telepítése a legegyszerűbb része ennek a bemutatónak. Jelentkezzen be Gitlab felhasználóként, és telepítse a közösségi kiadást. Természetesen azonnal telepíthet minden olyan szoftvert, amelyre robotjának szüksége van, például: Office 365.
{{< gallery match="images/12/*.png" >}}

## 6. lépés: Gitlab projekt és csővezeték létrehozása
Most jön a bemutató nagy fináléja. Létrehozok egy új Gitlab projektet, és ellenőrzöm az uiPath projektfájljaimat.
{{< gallery match="images/13/*.png" >}}
6.1.) Ezen kívül létrehozok egy új fájlt ".gitlab-ci.yml" a következő tartalommal:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
A Windows szoftverrobotom közvetlenül a master ágba történő átadás után kerül végrehajtásra:
{{< gallery match="images/14/*.png" >}}
A robot automatikus indítása az "Ütemezés" opcióval kezelhető. Ennek a kombinációnak nagy előnye, hogy a "robotikus" projektek és a projekt eredményei (artefaktumok) központilag ellenőrizhetők, verziókezelhetők és kezelhetők a Gitlab által más "nem robotikus" projektekkel együtt.
