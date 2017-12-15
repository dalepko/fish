if status --is-interactive
    eval (python -m virtualfish auto_activation)
end

set PATH $PATH /opt/node/bin/

alias tvon "xrandr --output DVI-1 --off"
alias tvoff "xrandr --output DVI-1 --right-of DVI-0"
alias pyenv $HOME/.pyenv/bin/pyenv
