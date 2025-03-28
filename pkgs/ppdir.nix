{writeShellScriptBin}:
# a wrapper script that aborts if smart card is not inserted
writeShellScriptBin "ppdir" ''
  # Check if at least one directory is passed as an argument
  if [ "$#" -lt 1 ]; then
      echo "Usage: $0 <directory1> <directory2> ... <directoryN>"
      exit 1
  fi

  # Function to display contents of files
  display_contents() {
      local dir="$1"

      # Iterate through all files and directories
      for item in "$dir"/*; do
          if [ -d "$item" ]; then
              # If it's a directory, recursively call this function
              display_contents "$item"
          elif [ -f "$item" ]; then
              # If it's a file, print its name and content
              echo "=== Contents of: $item ==="
              cat "$item"
              echo
          fi
      done
  }

  # Iterate over each argument passed to the script
  for dir in "$@"; do
      if [ -d "$dir" ]; then
          # echo "Processing directory: $dir"
          display_contents "$dir"
      else
          echo "Warning: $dir is not a valid directory."
      fi
  done
''
