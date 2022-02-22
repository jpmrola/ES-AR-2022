@echo off
title dump1090-startup
echo starting dump1090...
start cmd /k dump1090.exe --device-index 2 --net --net-bind-address 192.168.103.207 --net-http-port 29999 --quiet
start cmd /k docker exec -it dump1090 socat -d -d TCP:192.168.103.207:30002, TCP:localhost:30006 &
pause
