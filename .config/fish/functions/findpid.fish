function findpid
	ps axww -o pid,user,%cpu,%mem,start,time,command | fzy | sed 's/^ *//' | cut -f1 -d' '
end
