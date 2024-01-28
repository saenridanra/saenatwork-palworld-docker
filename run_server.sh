#!/bin/bash

GAME_PATH="/palworld"

cd $GAME_PATH

function updateServer() {
    # force an update and validation
    echo "Updating Palworld Server"
    steamcmd +force_install_dir "$GAME_PATH" +login anonymous +app_update 2394010 validate +quit
}

if [ ! -f "$GAME_PATH/PalServer.sh" ]; then
    /setup_server.sh
fi

if [ $ALWAYS_UPDATE_ON_START == "true" ]; then
    updateServer
fi

if [[ -n $BACKUP_ENABLED ]] && [[ $BACKUP_ENABLED == "true" ]]; then
    # Preparing the cronlist file
    echo "$BACKUP_CRON_EXPRESSION /backup_server.sh" >> cronlist
    # Making sure supercronic is enabled and the cronfile is loaded
    /usr/local/bin/supercronic cronlist &
fi

START_OPTIONS="-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"

if [[ -n $COMMUNITY_SERVER ]] && [[ $COMMUNITY_SERVER == "true" ]]; then
    echo "Setting Community-Mode to enabled"
    START_OPTIONS="$START_OPTIONS EpicApp=PalServer"
fi

./PalServer.sh "$START_OPTIONS"