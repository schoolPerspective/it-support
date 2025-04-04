#!/usr/bin/bash

pkill -f scratch_link && sleep 1
bluepy_helper_cap
scratch_link -r 2 -s 8 &
scratch-desktop
