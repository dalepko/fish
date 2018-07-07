if status --is-interactive
    eval (python -m virtualfish auto_activation)
end

set PATH $PATH /opt/node/bin/

alias tvoff "xrandr --output HDMI-A-0 --off"
alias tvon "xrandr --output HDMI-A-0 --right-of DisplayPort-0 --auto"
alias pyenv $HOME/.pyenv/bin/pyenv
