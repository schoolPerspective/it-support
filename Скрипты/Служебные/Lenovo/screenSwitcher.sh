#!/usr/bin/bash

primary=eDP-1
secondary=HDMI-1

primary_res=1600x900
secondary_res=1920x1080


is_mirror() {
    xrandr | awk '
    / connected / {
        for (i = 1; i <= NF; i++) {
            if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) {
                if (ref == "")
                    ref = $i
                else if ($i != ref)
                    diff = 1

                n++
                break
            }
        }
    }

    END {
        exit !(n >= 2 && !diff)
    }'
}


set_mirror() {
    xrandr \
        --output "$secondary" \
            --mode "$secondary_res" \
            --pos 0x0 \
            --scale 1x1 \
        --output "$primary" \
            --mode "$primary_res" \
            --pos 0x0 \
            --scale-from "$secondary_res"
}


set_extend() {
    local primary_width=${primary_res%x*}

    xrandr \
        --output "$primary" \
            --mode "$primary_res" \
            --pos 0x0 \
            --scale 1x1 \
        --output "$secondary" \
            --mode "$secondary_res" \
            --pos "${primary_width}x0" \
            --scale 1x1
}


if is_mirror; then
    set_extend
else
    set_mirror
fi
