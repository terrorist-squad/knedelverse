+++
date = "2021-04-18"
title = "Готини неща с Atlassian: Собствени макроси в Confluence"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "confluence", "wiki", "macro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-Atlassian-Confluence-macro/index.bg.md"
+++
Confluence е златният стандарт в областта на базите знания. Създаването на собствени потребителски макроси на Confluence също е детска игра. Днес ще покажа как създадох макрос за терминал.
{{< gallery match="images/1/*.png" >}}

## Стъпка 1: Създаване на потребителски макрос
Щраквам върху "Потребителски макроси" > "Създаване на потребителски макрос" в областта "Администриране".
{{< gallery match="images/2/*.png" >}}
След това въвеждам името на потребителския макрос и избирам опцията "Дефиниране на потребителски макроси" - "Rendered".
{{< gallery match="images/3/*.png" >}}

## Стъпка 2: Разработване на потребителски макрос
Всеки "визуализиран" потребителски макрос има променлива body по подразбиране:
```
Inhalt $body

```
Всички останали променливи са дефинирани в макрокода. Още по темата за променливите
```

## @param Title:title=Заглавна лента Title|type=string|required=truel|default=Bash

```
Сега липсва малко HTML/CSS и Marco е готов! Например:
```

## @param Title:title=Заглавна лента Title|type=string|required=truel|default=Bash

<style>
.window a {
  text-decoration: none;
}
.window span {
  line-height: 9px;
  vertical-align: 50%;
}
.window p {
    padding:0;margin:0;
    font-size: 16px;
}
.window {
  font-family: HelveticaNeue, 'Helvetica Neue', 'Lucida Grande', Arial, sans-serif;
  background: #000;
  color: #48cf00;
  margin: 10px;
  border: 1px solid #acacac;
  border-radius: 6px;
  -webkit-box-shadow: 0px 0px 8px 0px rgba(112,112,112,1);
  -moz-box-shadow: 0px 0px 8px 0px rgba(112,112,112,1);
  box-shadow: 0px 0px 8px 0px rgba(112,112,112,1);
}
.titlebar {
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0.0, #ebebeb, color-stop(1.0, #d5d5d5)));
  background: -webkit-linear-gradient(top, #ebebeb, #d5d5d5);
  background: -moz-linear-gradient(top, #ebebeb, #d5d5d5);
  background: -ms-linear-gradient(top, #ebebeb, #d5d5d5);
  background: -o-linear-gradient(top, #ebebeb, #d5d5d5);
  background: linear-gradient(top, #ebebeb, #d5d5d5);
  color: #4d494d;
  font-size: 11pt;
  line-height: 20px;
  text-align: center;
  width: 100%;
  height: 20px;
  border-top: 1px solid #f3f1f3;
  border-bottom: 1px solid #b1aeb1;
  border-top-left-radius: 6px;
  border-top-right-radius: 6px;
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -o-user-select: none;
  cursor: default;
}
.buttons {
  padding-left: 8px;
  padding-top: 3px;
  float: left;
  line-height: 0px;
}
.close {
  background: #ff5c5c;
  font-size: 9pt;
  width: 11px;
  height: 11px;
  border: 1px solid #e33e41;
  border-radius: 50%;
  display: inline-block;
}
.closebutton {
  color: #820005;
  visibility: hidden;
  cursor: default;
}
.minimize {
  background: #ffbd4c;
  font-size: 9pt;
  line-height: 11px;
  margin-left: 4px;
  width: 11px;
  height: 11px;
  border: 1px solid #e09e3e;
  border-radius: 50%;
  display: inline-block;
}
.minimizebutton {
  color: #9a5518;
  visibility: hidden;
  cursor: default;
}
.zoom {
  background: #00ca56;
  font-size: 9pt;
  line-height: 11px;
  margin-left: 6px;
  width: 11px;
  height: 11px;
  border: 1px solid #14ae46;
  border-radius: 50%;
  display: inline-block;
}
.zoombutton {
  color: #006519;
  visibility: hidden;
  cursor: default;
}
.content {
  padding: 10px;
}
</style>
<div class="window">
    <div class="titlebar">
        <div class="buttons">
            <div class="close">
                <a class="closebutton" href="#"><span><strong>x</strong></span></a>
            </div>
            <div class="minimize">
                <a class="minimizebutton" href="#"><span><strong>&ndash;</strong></span></a>
            </div>
            <div class="zoom">
                <a class="zoombutton" href="#"><span><strong>+</strong></span></a>
            </div>
        </div>

        $paramTitle

    </div>
    <div class="content">
        <p>$body</p>
    </div>
</div>

```

## Стъпка 3: Използване на потребителски макрос
Ако потребителят marko е снабден с променливи, HTML и CSS, това може да се използва.
{{< gallery match="images/4/*.png" >}}