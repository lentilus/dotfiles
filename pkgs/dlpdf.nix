{ writeShellScriptBin }:
# a wrapper script that aborts if smart card is not inserted
writeShellScriptBin "dlpdf" ''
# -t sorts by time (latest first)
selection="$(ls -t "$HOME/Downloads" | grep ".pdf" | rofi -dmenu -i)" 

[ -z "$selection" ] && exit
zathura "$HOME/Downloads/$selection"
''
