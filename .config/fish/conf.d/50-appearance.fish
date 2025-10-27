#  ┏┓┏┓  ┏┓┏┓┏┓┏┓┏┓┳┓┏┓┳┓┏┓┏┓
#  ┣┓┃┫━━┣┫┃┃┃┃┣ ┣┫┣┫┣┫┃┃┃ ┣
#  ┗┛┗┛  ┛┗┣┛┣┛┗┛┛┗┛┗┛┗┛┗┗┛┗┛
#

# Autocomplete and highlight colors
#set -g fish_color_normal 	            brwhite
#set -g fish_color_autosuggestion      brblack
#set -g fish_color_command 	          brgreen
#set -g fish_color_error 	            brred
#set -g fish_color_param 	            brwhite

# Custom colours
cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
# Custom colours (filter out background to preserve transparency)
#grep -v ']11;' ~/.local/state/caelestia/sequences.txt 2> /dev/null


# Prompt (Starship)
starship init fish | source

