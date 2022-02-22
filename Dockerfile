FROM jrei/systemd-debian:bullseye

ENV container docker
VOLUME [ "/sys/fs/cgroup" ]
RUN apt-get update && apt-get install -y \
    socat \
    lighttpd \
    librtlsdr0 \
    libncurses6 \
    curl

COPY ./resources /root/resources
WORKDIR /root/resources/
RUN dpkg -i dump1090-fa_7.1_amd64.deb
RUN mv /root/resources/dump1090-fa /etc/default/dump1090-fa
WORKDIR /root/

CMD ["/lib/systemd/systemd"]
EXPOSE 30006/tcp 
EXPOSE 30007/tcp
EXPOSE 8080/tcp