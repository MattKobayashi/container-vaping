#!/bin/sh
pipx install https://github.com/20c/vaping/archive/4d5e0f182676bb7555cde8988230181be4d8d9c2.tar.gz
pipx inject --force --requirement /opt/container-vaping/requirements.txt vaping
vaping start --home=/opt/container-vaping --no-fork
