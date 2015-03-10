#!/bin/bash
# -*- mode: sh -*-
# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

set -e
stop()
{
    mqsistop $IIBNODE
}

iibnodestate()
{
    _RUNNINGBIP=BIP1325I
    _STOPPEDBIP=BIP1326I

    _LISTLINE=`mqsilist | grep "Integration node" | grep $IIBNODE |cut -f1,4 -d ' ' | tr -d "'" |tr -d ":"`
    _BIPMSG=$(echo $_LISTLINE | cut -f1 -d " ")
    _NODENAME=$(echo $_LISTLINE | cut -f2 -d " ")

    case "$_NODENAME" in
        "$IIBNODE" )
            if [ "$_BIPMSG" = "$_RUNNINGBIP" ]; then
                echo running
            else
                echo stopped
            fi
            ;;
        *)
            echo unknown
            ;;
        esac
}

config()
{
    _STATE=$(iibnodestate)
    case "$_STATE" in
        "unknown" )
            mqsicreatebroker $IIBNODE
            mqsistart $IIBNODE
            mqsicreateexecutiongroup $IIBNODE -e default
            mqsideploy $IIBNODE -e default -a $BARFILE
        ;;
        "stopped" )
            mqsistart ${IIBNODE}
            sleep 3
        ;;
    esac
}

monitor()
{
# Loop until "mqsilist" says node is stopped
    until [ "$(iibnodestate)" = "stopped" ]; do
        sleep 3
    done
    mqsilist
}

config
trap stop SIGTERM SIGINT
monitor