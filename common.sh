#!/usr/bin/env bash

set -e

function calculate_build_id()
{
    local TAG=$1
    local REGEX='-(preview|rc|rtm)\.[0-9]\.([0-9]{5})\.([0-9]{1,2})'

    if [[ $TAG =~ $REGEX ]]
    then
        local MAJOR=${BASH_REMATCH[2]}
        local MINOR=${BASH_REMATCH[3]}

        YEAR=$((MAJOR / 1000 + 2000))
        MONTH=$(((MAJOR % 1000) / 50))
        DAY=$((MAJOR % 50))

        DATE=$((YEAR * 10000 + MONTH * 100 + DAY))
        
        OFFICIALBUILDID="${DATE}.${MINOR}"
    else
        OFFICIALBUILDID=$(date +%Y%m%d).99
    fi
    echo $OFFICIALBUILDID
}

calculate_build_id $1
