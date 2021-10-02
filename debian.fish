set PATH $PATH /opt/node/bin/ $HOME/.pyenv/bin/

alias tvoff "xrandr --output HDMI-A-0 --off"
alias tvon "xrandr --output HDMI-A-0 --right-of DisplayPort-0 --auto"
alias duplicate "xrandr --output HDMI-A-0 --mode 1360x768 --same-as DisplayPort-0 --output DisplayPort-0 --scale-from 1360x768"
alias pyenv $HOME/.pyenv/bin/pyenv
