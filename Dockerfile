FROM        debian:bullseye-slim

ENV         DEBIAN_FRONTEND=noninteractive

RUN         dpkg --add-architecture i386 && sed -i "s@http://\(deb\|security\).debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list && apt update  \
            && apt install -y software-properties-common && apt-add-repository non-free && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y tar curl gcc g++ wget lib32gcc-s1 libgcc1 libcurl4-gnutls-dev:i386 libssl1.1:i386 libcurl4:i386 lib32tinfo6 libtinfo6:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libsdl2-2.0-0:i386 libsdl2-2.0-0 iproute2 gdb libsdl1.2debian libfontconfig1 telnet net-tools netcat tzdata numactl xvfb tini steamcmd \
            && useradd -m -d /home/container container
## install rcon
RUN         cd /tmp/ \
            && curl -sSL https://ghproxy.net/https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz \
            && tar xvf rcon.tar.gz \
            && mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/

## install Manually
RUN         mkdir /home/container/Steam && cd /home/container/Steam && wget -O /home/container/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar -zxvf steamcmd_linux.tar.gz && ./steamcmd.sh +login anonymous +app_update 2394010 +app_update 1007 validate +quit && mkdir /home/container/.steam && mkdir /home/container/.steam/sdk64 && cp /home/container/Steam/steamapps/common/Steamworks\SDK\Redist/linux64/steamclient.so /home/container/.steam/sdk64/ && chmod -R 777 /home/container/*

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
