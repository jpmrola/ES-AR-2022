@echo off
title dump1090-startup
echo starting dump1090...
wsl -u root rm -r /run/dump1090-fa
wsl -u root mkdir /run/dump1090-fa
wsl -u root /etc/init.d/lighttpd start
start cmd /k dump1090.exe --device-index 2 --net --net-bind-address 127.0.0.1 --net-http-port 29999
Rem nao sei se o device index funciona com serial number, tenho de experimentar
start cmd /k wsl -u root dump1090-fa --net-only --net-bind-address 127.0.0.1 --net-ri-port 30006 --net-ro-port 30007 --write-json /run/dump1090-fa --write-json-every 0.2
timeout 5 /nobreak
wsl -u root socat - TCP4:192.168.103.7:30002 | socat - TCP4:127.0.0.1:30006
Rem start cmd /k wsl -u root nc localhost 127.0.0.1 30002 | nc localhost 30006
pause
