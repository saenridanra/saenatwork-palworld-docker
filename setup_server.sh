#!/bin/bash

GAME_PATH="/palworld"

function updatePalworldSettings() {
    if [[ ! -z ${SERVER_NAME+x} ]]; then
        sed -E -i "s/ServerName=\"[^\"]*\"/ServerName=\"$SERVER_NAME\"/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${SERVER_DESCRIPTION+x} ]]; then
        sed -E -i "s/ServerDescription=\"[^\"]*\"/ServerDescription=\"$SERVER_DESCRIPTION\"/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${ADMIN_PASSWORD+x} ]]; then
        sed -E -i "s/AdminPassword=\"[^\"]*\"/AdminPassword=\"$ADMIN_PASSWORD\"/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${SERVER_PASSWORD+x} ]]; then
        sed -E -i "s/ServerPassword=\"[^\"]*\"/ServerPassword=\"$SERVER_PASSWORD\"/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${PUBLIC_IP+x} ]]; then
        sed -E -i "s/PublicIP=\"[^\"]*\"/PublicIP=\"$PUBLIC_IP\"/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${PUBLIC_PORT+x} ]]; then
        sed -E -i "s/PublicPort=[0-9]*/PublicPort=$PUBLIC_PORT/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${RCON_ENABLED+x} ]]; then
        sed -E -i "s/RCONEnabled=[a-zA-Z]*/RCONEnabled=$RCON_ENABLED/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi

    if [[ ! -z ${MAX_PLAYERS+x} ]]; then
        sed -E -i "s/ServerPlayerMaxNum=[0-9]*/ServerPlayerMaxNum=$MAX_PLAYERS/" ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
}

function installServer() {
    # force a fresh install of all
    echo "Installing Palworld Server"

    steamcmd +force_install_dir "$GAME_PATH" +login anonymous +app_update 2394010 validate +quit

    mkdir -p ${GAME_PATH}/Pal/Saved/Config/LinuxServer

    cp ${GAME_PATH}/DefaultPalWorldSettings.ini ${GAME_PATH}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

    updatePalworldSettings
}

installServer