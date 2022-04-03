+++
date = "2022-04-02"
title = "Grandes coisas com contentores: Instalação de Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.pt.md"
+++
Com Jitsi você pode criar e implantar uma solução de videoconferência segura. Hoje eu mostro como instalar um serviço Jitsi em um servidor, referência: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Passo 1: Criar a pasta "jitsi
Eu crio um novo diretório chamado "jitsi" para a instalação.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Passo 2: Configuração
Agora eu copio a configuração padrão e adapto-a.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Veja:
{{< gallery match="images/1/*.png" >}}
Para usar senhas fortes nas opções de segurança do arquivo .env, o seguinte script de bash deve ser executado uma vez.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Agora vou criar mais algumas pastas para o Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
O servidor Jitsi pode então ser iniciado.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Depois disso, você pode usar o servidor Jitsi!
{{< gallery match="images/2/*.png" >}}

