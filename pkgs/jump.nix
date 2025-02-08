{writeShellScriptBin}:
writeShellScriptBin "jump" ''
  target="$HOME/git"
  selected=$(find "$target" -maxdepth 1 -type d -printf '%P\n' | fzf)
  selected_name="''${selected//./_}"

  [[ -z $selected_name ]] && exit

  if ! tmux has-session -t="$selected_name" 2> /dev/null; then
      tmux new-session -ds "$selected_name" -c "$target/$selected" "$SHELL"
  fi

  tmux switch-client -t "$selected_name"
''
