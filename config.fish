set -l host_file ~/.config/fish/(hostname).fish

if test -f $host_file
    source $host_file
end

if test -d ~/bin
    set PATH ~/bin $PATH
end

# aliases
alias gcm "git commit -m"
alias gca "git commit --amend"
alias e "emacsclient -nw"



# fzf config
switch (uname)
case Linux
    alias fzf ~/.config/fish/libexec/fzf-linux
case Darwin
    alias fzf ~/.config/fish/libexec/fzf-mac
end

set -gx FZF_DEFAULT_OPTS "--height 5 --color=bw"

# helpers
complete -Cgit --do-complete='git commit' > /dev/null

function inherit_git_completions 
    set -l subcommand $argv[1]
    set -l fname $argv[2]
    set -l filter
    
    if [ (count $argv) -gt 2 ]
        set filter " --long-option ("(string join '|' $argv[3..-1])")"
    else
        set filter "--no-match--"
    end
    
    complete | \
    grep -e " --condition '__fish_git_using_command $subcommand'\$" | \
    sed "s/ --condition .*\$//; s/--command git /--command $fname /" | \
    grep -Eve $filter | \
    source
end

