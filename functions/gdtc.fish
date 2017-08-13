function gdtc
	git difftool --cached $argv;
end

inherit_git_completions difftool gdtc cached

