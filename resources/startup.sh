#!/bin/sh

bash -c "$(curl -L -o - https://github.com/wiedehopf/graphs1090/raw/master/install.sh)"

socat -d -d TCP:192.168.103.207:30002, TCP:localhost:30006 & 