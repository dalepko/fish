function de
	docker exec -ti $argv
end

complete -Cdocker --do-complete='docker exec' > /dev/null

complete | \
grep -e ' --comand docker ' -e " --condition '__fish_seen_subcommand_from exec'\$" | \
grep -Eve ' --long-option (tty|interactive) ' | \
sed 's/ --condition .*$//; s/ --command docker / --command de /' | \
source
