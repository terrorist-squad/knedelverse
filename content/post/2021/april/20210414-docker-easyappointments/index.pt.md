+++
date = "2021-04-16"
title = "Criativo para sair da crise: reservar um serviço com pontuações fáceis"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.pt.md"
+++
A crise da Corona está a atingir duramente os prestadores de serviços na Alemanha. Ferramentas e soluções digitais podem ajudar a atravessar a pandemia de Corona da forma mais segura possível. Nesta série tutorial "Criativo para sair da crise" eu mostro tecnologias ou ferramentas que podem ser úteis para pequenas empresas. Hoje eu mostro "Easyappointments", uma ferramenta de reserva "click and meet" para serviços, por exemplo cabeleireiros ou lojas. Easyappointments consiste em duas áreas:
## Área 1: Backend
Um "backend" para a gestão de serviços e compromissos.
{{< gallery match="images/1/*.png" >}}

## Área 2: Frontend
Uma ferramenta do usuário final para marcar compromissos. Todas as marcações já marcadas são então bloqueadas e não podem ser marcadas duas vezes.
{{< gallery match="images/2/*.png" >}}

## Instalação
Já instalei Easyappointments várias vezes com o Docker-Compose e posso recomendar vivamente este método de instalação. Eu crio um novo diretório chamado "easyappointments" no meu servidor:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Então eu vou para o diretório easyappointments e crio um novo arquivo chamado "easyappointments.yml" com o seguinte conteúdo:
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Este ficheiro é iniciado através do Docker Compose. Em seguida, a instalação é acessível sob o domínio/porto pretendido.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Criar um serviço
Os serviços podem ser criados em "Serviços". Cada novo serviço deve então ser atribuído a um fornecedor/utilizador de serviços. Isto significa que posso reservar funcionários ou prestadores de serviços especializados.
{{< gallery match="images/3/*.png" >}}
O consumidor final também pode escolher o serviço e o prestador de serviços preferido.
{{< gallery match="images/4/*.png" >}}

## Horário de trabalho e pausas
O horário de serviço geral pode ser definido em "Configurações" > "Lógica de Negócios". No entanto, o horário de trabalho dos prestadores de serviços/utilizadores também pode ser alterado no "Plano de trabalho" do utilizador.
{{< gallery match="images/5/*.png" >}}

## Resumo e diário de reservas
O calendário de marcações torna todas as marcações visíveis. Naturalmente, as reservas também podem ser criadas ou editadas lá.
{{< gallery match="images/6/*.png" >}}

## Ajustes de cor ou lógicos
Se você copiar o diretório "/app/www" e incluí-lo como um "volume", então você pode adaptar as folhas de estilo e a lógica como desejar.
{{< gallery match="images/7/*.png" >}}
