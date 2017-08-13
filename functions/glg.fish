function glg
	git log --graph --oneline --decorate=short $argv;
end

inherit_git_completions log glg graph oneline decorate
