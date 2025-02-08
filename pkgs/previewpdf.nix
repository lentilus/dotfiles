{writeShellScriptBin}:
writeShellScriptBin "previewpdf" ''
  FILE=$1
  TEMPFILE="/tmp/zathura_pid"
  LOCKFILE="/tmp/zathura_lock"
  LOGFILE="/tmp/zathura_log"

  exec &> "$LOGFILE"

  # Trap for cleanup on script exit
  cleanup() {
    # sleep a little to debounce
    echo "Releasing lock and exiting..."
    flock -u 200
    rm -f "$LOCKFILE"
  }

  trap cleanup EXIT

  # Function to get the PID of the currently running Zathura instance
  get_pid() {
    if [ -f "$TEMPFILE" ]; then
      ZATHURA_PID=$(cat "$TEMPFILE")
    else
      ZATHURA_PID=""
    fi
  }

  # Function to send the DBus command to the Zathura instance
  send_dbus_command() {
    # Construct the DBus destination dynamically based on PID
    DBUS_DEST="org.pwmt.zathura.PID-$ZATHURA_PID"

    echo "DBUS_DEST is $DBUS_DEST"

    dbus-send --session \
      --dest="$DBUS_DEST" \
      --type=method_call \
      --print-reply \
      /org/pwmt/zathura \
      org.pwmt.zathura.OpenDocument \
      string:"$FILE" \
      string:"" \
      int32:1 >/dev/null
  }


  # Acquire lock
  exec 200>"$LOCKFILE"
  flock -n 200 || {
    echo "Another instance is running. Exiting..."
    exit 1
  }

  ### do work ###

  # Check if the Zathura instance is running and its PID is valid
  get_pid

  # If there is no valid PID or DBus communication fails, launch a new instance
  if [ -z "$ZATHURA_PID" ] || ! ps -p "$ZATHURA_PID" || ! send_dbus_command; then
    echo "pid not set, not running, or dbus command failed. Starting a new instance."
    # Launch Zathura and capture the PID
    zathura &
    ZATHURA_PID=$!

    echo "PID from the process is $ZATHURA_PID"

    # Wait briefly to allow Zathura to start up
    sleep 1

    # Update the temporary file with the new PID
    echo "$ZATHURA_PID" > "$TEMPFILE"

    # Try to send the DBus command again
    if ! send_dbus_command; then
      echo "Error: Failed to send DBus command to Zathura."
      exit 1
    fi
  fi

  echo "Done. Releasing lock."
''
