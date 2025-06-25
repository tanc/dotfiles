function down-line-or-select() {
  if [[ -n $LBUFFER ]]; then
    zle beginning-of-line
    zle history-substring-search-down
  else
    # Use autocomplete's menu if available
    zle complete-word  # fallback
  fi
}
