complete --command ec2ssh --arguments '(~/bin/ec2ssh --complete "" "")'

if status --is-interactive
    source (pyenv init - | sed s/setenv/set/ | psub)
    # "source (pyenv virtualenv-init -|psub)" is miserably slow


    function __pyenv_auto_activate --on-variable PWD
        # find an auto-activation file
        set -l activation_root $PWD

        while test $activation_root != ""
            if test -f $activation_root/.python-version
                set -gx PYENV_VERSION (cat $activation_root/.python-version)
                return
            end
            # this strips the last path component from the path.
            set activation_root (echo $activation_root | sed 's|/[^/]*$||')
        end

        set -e PYENV_VERSION
    end

    __pyenv_auto_activate
end
