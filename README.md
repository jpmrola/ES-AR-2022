# Projeto ES 2021/2022 - Grupo AR

## Resumo

No seguinte repo, encontra-se a solução utilizada para descodificar as transmissões ADS-B.
Esta é composta por duas instâncias do programa dump1090 ligadas por uma socket TCP,
sendo que uma instância corre como programa nativo Windows e outra como um container Docker.  
A instância no container Docker também funciona como webserver, que será utilizado para enviar
ficheiros JSON à equipa de UI com os dados das aeronaves.

## Requisitos

* RTL-SDR + antena
* Instalação dos drivers RTL-SDR com [Zadig](https://www.rtl-sdr.com/rtl-sdr-quick-start-guide/)
* Windows com WSL2 (Windows Build 18362 ou mais alto) - [Instalação do WSL2](https://docs.microsoft.com/en-us/windows/wsl/install)
* Docker - [Instalação Docker for Desktop Windows](https://docs.docker.com/desktop/windows/install/)

### Configuração

A configuração do dump1090 é feita através do ficheiro em /resources/dump1090-fa, este permite 
alterar o funcionamento do programa dump1090.  
Se for alterado dentro do container enquanto este está a correr, em /etc/default/dump1090, 
será necessário reiniciar o serviço com:

    systemctl restart dump1090-fa

Nos ficheiros ***dump1090.bat*** e ***dump1090-docker.bat*** o IP da máquina tem de ser escrito, neste
caso 192.168.103.207.

Se apenas estiver a ser utilizado um RTL-SDR, ou o índice do RTL-SDR pretendido aparece como 1, 
modificar valores de ***--device-index*** nos ficheiros referidos anteriormente para 1.

As portas TCP configuradas são:
* Windows - 30001,30002 (hex input, hex output)
* Container - 30006,30007 (hex input, hex output)

### Utilização

De modo a correr a solução pela primeira vez, o ficheiro ***dump1090-docker.bat*** deve ser executado.
Este chamará o Dockerfile para criar a imagem do container, e em seguida irá iniciar os programas.  
Correr este ficheiro outra vez irá reinstalar o container Docker.

Se o container já se encontra operacional, mas a sua socket caiu, esta pode ser reiniciada ao 
fechar o dump1090 do Windows e correr o ***dump1090.bat***.

O dump1090 no container funciona como serviço systemd, logo para reiniciar, parar, ou começar:

    systemctl restart/stop/start dump1090-fa

Se for necessário aceder ao container Docker, no cmd escrever:

    docker exec -it dump1090 /bin/bash

Se for necessário apenas correr o dump1090 em Windows, no cmd escrever:

    dump1090.exe --device-index 2

Para aceder ao webserver, apontar o browser para [http://localhost:8080](http://localhost:8080).  
O JSON pode ser consultado em [http://localhost:8080/data/aircraft.json](http://localhost:8080/data/aircraft.json).  
Os gráficos podem ser consultados em [http://localhost:8080/graphs1090](http://localhost:8080/graphs1090).

### Porquê Docker? 

De modo a ser possível utilizar o fork do dump1090 da FlightAware, pois este apenas é
compatível com sistemas operativos baseados em Debian. Este fork possuí output 
de ficheiros JSON através de um webserver, uma funcionalidade muito útil para o use-case do grupo.

O container Docker também permite a utilização do programa graphs1090 que permite gerar gráficos
relevantes à performance do sistema. Este programa não é compatível com Windows ou WSL, devido 
à sua dependência no systemd do Linux para recolher logs.

O container e o WSL não têm acesso direto ao USB, logo é necessário utilizar as portas TCP 
do dump1090 nativo no Windows para transmitirem as mensagens em hexadecimal ao container.


