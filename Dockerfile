FROM ubuntu:22.04

LABEL maintainer="saenridanra"
ARG DEBIAN_FRONTEND=noninteractive
ARG SERVER_NAME=saenatwork
ARG SERVER_DESCRIPTION="Palworld-Dedicated-Server running in Docker by saenatwork"
ARG ADMIN_PASSWORD=xxx
ARG SERVER_PASSWORD=xxx
ARG BACKUP_ENABLED=true
ARG MAX_PLAYERS=8
ARG PUBLIC_IP=
ARG PUBLIC_PORT=8211
ARG RCON_ENABLED=true
ARG COMMUNITY_SERVER=false
ARG ALWAYS_UPDATE_ON_START=true

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Update system
RUN apt update && apt upgrade -y

RUN apt install software-properties-common -y

RUN dpkg --add-architecture i386

RUN add-apt-repository multiverse

RUN apt update

EXPOSE 8211/udp
EXPOSE 25575/tcp

# Install Steam CMD
RUN echo "**** Install SteamCMD ****" \
  && echo steam steam/question select "I AGREE" | debconf-set-selections \
  && echo steam steam/license note '' | debconf-set-selections \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates locales lib32gcc-s1 libsdl2-2.0-0:i386 steamcmd

# User
RUN useradd -m steam

RUN mkdir /palworld \
    && chown steam:steam /palworld

ADD --chown=steam:steam --chmod=755 setup_server.sh /setup_server.sh
ADD --chown=steam:steam --chmod=755 run_server.sh /run_server.sh
ADD --chown=steam:steam --chmod=755 backup_server.sh /backup_server.sh

VOLUME [ "/palworld" ]

RUN echo "export PATH=\"/usr/games/:$PATH\"" >> /home/steam/.bashrc

RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

USER steam

ENV DEBIAN_FRONTEND=noninteractive \
    PUID=0 \
    PGID=0 \
    TZ=Europe/Berlin \
    ALWAYS_UPDATE_ON_START=$ALWAYS_UPDATE_ON_START \
    MULTITHREAD_ENABLED=true \
    COMMUNITY_SERVER=$COMMUNITY_SERVER \
    BACKUP_ENABLED=$BACKUP_ENABLED \
    BACKUP_CRON_EXPRESSION="0 * * * *" \
    NETSERVERMAXTICKRATE=120 \
    MAX_PLAYERS=$MAX_PLAYERS \
    SERVER_NAME=$SERVER_NAME \
    SERVER_DESCRIPTION=$SERVER_DESCRIPTION \
    ADMIN_PASSWORD=$ADMIN_PASSWORD \
    SERVER_PASSWORD=$SERVER_PASSWORD \
    PUBLIC_IP=$PUBLIC_IP \
    PUBLIC_PORT=$PUBLIC_PORT \
    RCON_ENABLED=$RCON_ENABLED

RUN steamcmd +force_install_dir '/home/steam/Steam/steamapps/common/steamworks' +login anonymous +app_update 1007 +quit

RUN mkdir -p /home/steam/.steam/sdk64

RUN cp '/home/steam/Steam/steamapps/common/steamworks/linux64/steamclient.so' /home/steam/.steam/sdk64/

#RUN steamcmd +force_install_dir '/palworld' +login anonymous +app_update 2394010 validate +quit

ENTRYPOINT ["/run_server.sh"]
CMD ["+help", "+quit"]