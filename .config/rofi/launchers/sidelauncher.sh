#!/usr/bin/env bash
#  ┏┓┳┳┓┏┓  ┓ ┏┓┳┳┳┓┏┓┓┏┏┓┳┓
#  ┗┓┃┃┃┣ ━━┃ ┣┫┃┃┃┃┃ ┣┫┣ ┣┫
#  ┗┛┻┻┛┗┛  ┗┛┛┗┗┛┛┗┗┛┛┗┗┛┛┗
#                           



# Dirs
dir="$HOME/.config/rofi/launchers/sidelaunchers"
theme='style-1'

# Run
pkill rofi || true && rofi -show drun -theme ${dir}/${theme}.rasi
