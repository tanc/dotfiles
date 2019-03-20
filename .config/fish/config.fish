# thefuck - installed with homebrew
eval (thefuck --alias | tr '\n' ';')

#function fish_user_key_bindings
#  bind \e\e 'thefuck-command-line'  # Bind EscEsc to thefuck
#end

set -g theme_title_use_abbreviated_path no

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
rvm default

set -x GPG_TTY (tty)
set PATH $PATH $HOME/.composer/vendor/bin
#set -U fish_user_paths "/usr/local/sbin" $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/php@5.6/bin" $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/php@5.6/sbin" $fish_user_paths
