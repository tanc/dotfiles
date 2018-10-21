function fish_user_key_bindings
    ### user ###
    bind \e\[A 'history --merge ; up-or-search'
    bind -M insert -k dc delete-char
    ### user ###
    ### bang-bang ###
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
    ### bang-bang ###
    ### fzy ###
    bind \cr 'fzy_select_history (commandline -b)'
    ### fzy ###
end

fzf_key_bindings
