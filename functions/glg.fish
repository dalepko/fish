function glg
	git log --graph --pretty=format:'%C(yellow)%h%C(auto)%d %s %C(dim cyan)<%aN>%Creset' --decorate=short $argv;
end

inherit_git_completions log glg graph oneline decorate
