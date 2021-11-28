function in_color
    set_color $argv[1]
    echo -n $argv[2]
    set_color normal
end

function git_info
    set -l head_name (git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)

    if [ (count $head_name) -gt 0 ];
        set -l branch_status ""
        set -l head_color green

        if [ $head_name = "HEAD" ]
            set -l fancy_name (git describe --exact-match --all HEAD 2> /dev/null)
            if [ (count $fancy_name) -eq 1 ]
                set head_name $fancy_name
            end
        else
            set head_color blue
            set -l upstream (git rev-parse --symbolic-full-name --abbrev-ref "@{u}" 2> /dev/null)
            if [ (count $upstream) -eq 1 ]
                set -l updown (git rev-list HEAD...$upstream --count --left-right 2> /dev/null | tr '\t' '\n')

                if [ (count $updown) -eq 2 ]
                    set -l up $updown[1]
                    set -l down $updown[2]
                    if [ $up -eq 0 ]
                        if [ $down -eq 0 ]
                            set branch_status ''
                        else
                            set branch_status (in_color red ⬇)
                        end
                    else
                        if [ $down -eq 0 ]
                            set branch_status (in_color red ⬆)
                        else
                            set branch_status (in_color red ⬍)
                        end
                    end
                end
            end
        end
        set git_status (in_color $head_color $head_name)$branch_status
        echo -n $git_status
    end
end


function venv_info
    if begin; set -q VIRTUAL_ENV; and test (basename "$VIRTUAL_ENV") != 'default'; end
        echo -n -s "(" (basename "$VIRTUAL_ENV") ")"
    else if begin set -q PYENV_VERSION; and test $PYENV_VERSION != 'default'; end
        echo -n -s "($PYENV_VERSION)"
    else if begin set -q __pyenv; and test $__pyenv != 'default'; end
        echo -n -s "($__pyenv)"
    end
end


function fish_prompt --description 'Write out the prompt'
    set -l parts (venv_info) (git_info)

    echo -sn (in_color purple $USER) ":" "$parts " (in_color green (prompt_pwd)) "> "
end
