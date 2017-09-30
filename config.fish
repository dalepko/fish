if status is-interactive

    set -l host_file ~/.config/fish/(hostname).fish

    if test -f $host_file
        source $host_file
    end

    if test -d ~/bin
        set PATH ~/bin $PATH
    end

    set -l creds_file ~/.config/creds.fish

    if test -f $creds_file
        source $creds_file
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

    set -gx FZF_DEFAULT_OPTS "--height 5 --color=bw --tiebreak=index"

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

    # load virtualfish and auto-activate pyenv on .python-version files
    function __find_project_file --argument-names 'fname'
        set path (string split / $PWD)/

        while test (count $path) -gt 0
            set test_file (string join '' $path $fname)
            if test -f $test_file
                echo $test_file
                return 0
            end
            set -e path[-1]
        end

        return 1
    end

    function __pyenv_full_path --argument-names 'venv_name'
        set -q PYENV_ROOT; or set PYENV_ROOT ~/.pyenv
        readlink "$PYENV_ROOT/versions/$venv_name"
        or echo "$PYENV_ROOT/versions/$venv_name"
    end

    function __pyenv_deactivate --on-variable VIRTUAL_ENV
        if set -q __pyenv_current
            set old_path (__pyenv_full_path $__pyenv_current)"/bin"
            set new_path
            for item in $PATH
                if test $item != $old_path
                    set new_path $new_path $item
                end
            end
            set PATH $new_path
            set -e __pyenv_current
        end
    end

    function __pyenv_auto_activate --on-variable PWD
        if set fname (__find_project_file .python-version)
            set pyenv (cat $fname)
            if test $pyenv != "$__pyenv_current"
                set -gx VIRTUAL_ENV (__pyenv_full_path $venv_name)
                set -gx __pyenv_current $venv_name
                set PATH "$VIRTUAL_ENV/bin" $PATH
            end
        else if set -q __pyenv_current
            set -e VIRTUAL_ENV
        end
    end

    __pyenv_auto_activate
end
