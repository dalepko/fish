function gst
	git status --short $argv;
end

inherit_git_completions status gst short
