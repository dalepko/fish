if status is-interactive

    set -l host_file ~/.config/fish/(hostname).fish

    set FZF_CTRL_T_COMMAND "fd --type f . \$dir  | sed '1d; s#^\./##'"
    set FZF_CTRL_T_OPTS "--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

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
    end

    function remove_path --argument-names 'path'
        set new_path
        for item in $PATH
            if test $item != $path
                set new_path $new_path $item
            end
        end
        set PATH $new_path
    end

    # auto-activate pyenv on .python-version files
    set -g __pyenv_root ''
    set -g __nvm_root ''

    function __pyenv_full_path --argument-names 'venv_name'
        set -q PYENV_ROOT; or set PYENV_ROOT ~/.pyenv
        readlink "$PYENV_ROOT/versions/$venv_name"
        or echo "$PYENV_ROOT/versions/$venv_name"
    end


    function __pyenv_detect --on-variable PWD
        set fname (__find_project_file .python-version)
        set fname "$fname"
        if test $__pyenv_root != $fname
            set __pyenv_root $fname
        end
    end

    function __nvm_detect --on-variable PWD
        set fname (__find_project_file .nvmrc)
        set fname "$fname"
        if test $__nvm_root != $fname
            set __nvm_root $fname
        end
    end

    function __pyenv_active --on-variable __pyenv_root
        set -q PYENV_ROOT; or set PYENV_ROOT ~/.pyenv
        set shims $PYENV_ROOT/shims

        if set -q __pyenv
            remove_path $shims
            set -e __pyenv
            set -e VIRTUAL_ENV
        end

        if test $__pyenv_root != ''
            set -g __pyenv (cat $__pyenv_root)
            set PATH $shims $PATH
            set -gx VIRTUAL_ENV (__pyenv_full_path $__pyenv)
        end
    end

    function __nvm_active --on-variable __nvm_root
        set -q NVM_DIR; or set -gx NVM_DIR ~/.nvm

        if set -q NVM_BIN
            remove_path $NVM_BIN
            set -e NVM_BIN
        end

        if test $__nvm_root != ''
            set -gx NVM_BIN $NVM_DIR/versions/node/(cat $__nvm_root)/bin
            set PATH $NVM_BIN $PATH
        end
    end

    __pyenv_detect
    __nvm_detect
end
