#!/bin/sh
TAG=`cat runtime.tag`

runtime/build.sh --warnAsError false /p:OfficialBuildId=`./common.sh $TAG` -ci -c Release
