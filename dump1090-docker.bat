@echo off
title dump1090-docker
echo starting windows dump1090
start cmd /k dump1090.exe --device-index 2 --net --net-bind-address 192.168.103.207 --net-http-port 29999 --quiet
echo building docker container...
docker rm -f dump1090
docker image rm jrola/dump1090
docker build -t jrola/dump1090 .
docker run -d --name dump1090 --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 8080:8080 -p 30006:30006 -p 30007:30007 jrola/dump1090
docker exec -it dump1090 /root/resources/startup.sh
start cmd /k docker exec -it dump1090 /bin/bash
pause
