#  ┏━┏┓  ┏┓┳┳┏┳┓┏┓┏┓┏┳┓┏┓┳┓┏┳┓
#  ┗┓┃┫━━┣┫┃┃ ┃ ┃┃┗┓ ┃ ┣┫┣┫ ┃ 
#  ┗┛┗┛  ┛┗┗┛ ┻ ┗┛┗┛ ┻ ┛┗┛┗ ┻ 
#                             

if status is-interactive
    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source
end
