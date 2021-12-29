#!/bin/sh

sdk/build.sh -ci /p:OfficialBuildId=20211229.99 -c Release && sdk/build.sh -pack -ci /p:OfficialBuildId=20211229.99 -c Release
