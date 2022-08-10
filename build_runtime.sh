#!/bin/sh

# 20220126.8 - runtime - v7.0.0-preview.1.22076.8
# 20220325.4 - runtime - v7.0.0-preview.3.22175.4
# 20220429.4 - runtime - preview.4
# 20220601.12 - preview.5

runtime/build.sh --warnAsError false /p:OfficialBuildId=20220725.6 -ci -c Release
