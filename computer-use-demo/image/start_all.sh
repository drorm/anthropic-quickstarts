#!/bin/bash

set -e


export WIDTH=1024
export HEIGHT=768
export DISPLAY_NUM=0
export DISPLAY=:${DISPLAY_NUM}
./xvfb_startup.sh
./tint2_startup.sh
./mutter_startup.sh
./x11vnc_startup.sh
