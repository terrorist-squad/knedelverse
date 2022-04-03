+++
date = "2021-03-07"
title = "Grandes coisas com recipientes: gerenciar e arquivar receitas no Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.pt.md"
+++
Recolha todas as suas receitas favoritas no recipiente Docker e organize-as como desejar. Escreva suas próprias receitas ou importe receitas de websites, por exemplo "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Passo 1: Procura da imagem do Docker
Clico na guia "Registration" na janela do Synology Docker e procuro por "mealie". Selecciono a imagem do Docker "hkotel/mealie:latest" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Passo 2: Colocar a imagem em funcionamento:
Faço duplo clique na minha imagem de "refeição".
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta com este caminho de montagem "/app/data".
{{< gallery match="images/4/*.png" >}}
Eu atribuo portos fixos para o contentor "Mealie". Sem portas fixas, poderia ser que o "Mealie server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/5/*.png" >}}
Finalmente, introduzo duas variáveis de ambiente. A variável "db_type" é o tipo de base de dados e "TZ" é o fuso horário "Europa/Berlim".
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o Mealie Server pode ser iniciado! Em seguida, você pode chamar Mealie através do endereço Ip do disco Synology e da porta designada, por exemplo http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Como funciona o Mealie?
Se eu mover o mouse sobre o botão "Plus" à direita/bottom e depois clicar no símbolo "Chain", eu posso inserir uma url. A aplicação Mealie procura então automaticamente as meta e informações do esquema necessárias.
{{< gallery match="images/8/*.png" >}}
A importação funciona muito bem (já usei estas funções com urls do Chef, Food
{{< gallery match="images/9/*.png" >}}
No modo de edição, também posso adicionar uma categoria. É importante que eu pressione a tecla "Enter" uma vez após cada categoria. Caso contrário, esta configuração não é aplicada.
{{< gallery match="images/10/*.png" >}}

## Características especiais
Notei que as categorias do menu não são actualizadas automaticamente. Você tem que ajudar aqui com o recarregamento de um navegador.
{{< gallery match="images/11/*.png" >}}

## Outras características
Claro, você pode pesquisar receitas e também criar menus. Além disso, você pode personalizar "Mealie" muito extensivamente.
{{< gallery match="images/12/*.png" >}}
A refeição também fica óptima no telemóvel:
{{< gallery match="images/13/*.*" >}}

## Descanso-Api
A documentação da API pode ser encontrada em "http://gewaehlte-ip:und-port ... /docs". Aqui você encontrará muitos métodos que podem ser usados para a automação.
{{< gallery match="images/14/*.png" >}}

## Exemplo da Api
Imagine a seguinte ficção: "Gruner und Jahr lança o portal de internet Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Depois limpe esta lista e atire-a contra os outros api, por exemplo:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Agora você também pode acessar as receitas offline:
{{< gallery match="images/15/*.png" >}}
Conclusão: Se você colocar algum tempo na Mealie, você pode construir uma grande base de dados de receitas! O Mealie está constantemente a ser desenvolvido como um projecto de fonte aberta e pode ser encontrado no seguinte endereço: https://github.com/hay-kot/mealie/
