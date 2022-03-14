+++
date = "2020-02-07"
title = "Orquestrar robôs uiPath Windows com Gitlab"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.pt.md"
+++
O UiPath é um padrão estabelecido na automação de processos robóticos. Com o uiPath, você pode desenvolver um robô/bot baseado em software que cuida do processamento de dados complexos ou tarefas de clique para você. Mas um robô assim também pode ser controlado com Gitlab?a resposta curta é "sim". E como pode ver exactamente aqui. Para os seguintes passos, você precisa de direitos de administração e alguma experiência em uiPath, Windows e Gitlab.
## Passo 1: A primeira coisa a fazer é instalar um runner Gitlab.
1.1.) Crie um novo usuário Gitlab para o seu sistema operacional alvo. Clique em "Definições" > "Família e outros utilizadores" e depois em "Adicionar outra pessoa a este PC".
{{< gallery match="images/1/*.png" >}}
1.2.) Clique em "I don't know the credentials for this person" e depois em "Add user without Microsoft account" para criar um utilizador local.
{{< gallery match="images/2/*.png" >}}
1.3.) No diálogo seguinte você pode selecionar livremente o nome de usuário e a senha:
{{< gallery match="images/3/*.png" >}}

## Passo 2: Activar o logon de serviço
Se você quiser usar um usuário local separado para o seu Windows Gitlab Runner, então você deve "Ativar logon como um serviço". Para isso, vá para o menu Windows > "Política de Segurança Local". Aí, selecione "Política Local" > "Atribuir Direitos de Usuário" no lado esquerdo e "Logon como Serviço" no lado direito.
{{< gallery match="images/4/*.png" >}}
Depois adicione o novo usuário.
{{< gallery match="images/5/*.png" >}}

## Passo 3: Registre o Gitlab Runner
O instalador do Windows para o Gitlab Runner pode ser encontrado na seguinte página: https://docs.gitlab.com/runner/install/windows.html . Eu criei uma nova pasta na minha unidade "C" e coloquei o instalador lá.
{{< gallery match="images/6/*.png" >}}
3.1.) Eu uso o comando "CMD" como "Administrador" para abrir um novo console e mudar para um diretório "cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}
Aí eu chamo o seguinte comando. Como você pode ver, eu também digito o nome de usuário e senha do usuário do Gitlab aqui.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"

{{</ terminal >}}
3.2.) Agora o corredor de Gitlab pode ser registado. Se você usar um certificado autoassinado para sua instalação do Gitlab, você tem que fornecer o certificado com o atributo "-tls-ca-file=". Depois introduza a url do Gitlab e a ficha de registo.
{{< gallery match="images/8/*.png" >}}
3.2.) Após o registo bem sucedido, o corredor pode ser iniciado com o comando "gitlab-runner-windows-386.exe start":
{{< gallery match="images/9/*.png" >}}
Ótimo! O seu Gitlab Runner está a funcionar e é utilizável.
{{< gallery match="images/10/*.png" >}}

## Passo 4: Instalar o Git
Como um runner Gitlab funciona com Git versioning, Git for Windows também deve ser instalado:
{{< gallery match="images/11/*.png" >}}

## Passo 5: Instalar o UiPath
A instalação do UiPath é a parte mais fácil deste tutorial. Entre como usuário do Gitlab e instale a edição da comunidade. Naturalmente, você pode instalar imediatamente todo o software que seu robô precisa, por exemplo: Office 365.
{{< gallery match="images/12/*.png" >}}

## Passo 6: Criar projeto Gitlab e gasoduto
Agora vem o grande final deste tutorial. Eu crio um novo projeto Gitlab e verifico nos meus arquivos do projeto uiPath.
{{< gallery match="images/13/*.png" >}}
6.1.) Além disso, eu crio um novo arquivo ".gitlab-ci.yml" com o seguinte conteúdo:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"

```
Meu robô de software Windows é executado diretamente após o committing para a filial mestre:
{{< gallery match="images/14/*.png" >}}
