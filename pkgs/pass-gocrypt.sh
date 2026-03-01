#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2022 Peter Cai <peter at typeblog dot net>
# modified 2025 by Lentilus <lentilus@mailbox.org>

readonly gocryptfs="gocryptfs"
readonly gocrypt_dir=".gocrypt"
readonly gocrypt_dec_dir="gocrypt"
readonly gocrypt_passwd_file="gocrypt-passwd"
readonly gocrypt_needs_passphrase_marker=".gocrypt-needs-passphrase"
readonly gocrypt_close_timeout="300"

gocrypt_sys_check() {
    which "$gocryptfs" > /dev/null || gocrypt_die "gocryptfs not found in PATH"
}

gocrypt_env_check() {
    gocrypt_sys_check
    [ ! -d "$gocrypt_dir" ] && gocrypt_die "gocrypt plugin not initialized"
}

gocrypt_close_check() {
    gocrypt_env_check
    [ -f "$gocrypt_dec_dir"/.pass-gocrypt ] && gocrypt_die "gocrypt already opened"
}

gocrypt_open_check() {
    gocrypt_env_check
    [ ! -f "$gocrypt_dec_dir"/.pass-gocrypt ] && gocrypt_die "gocrypt not opened"
}

gocrypt_die() {
    printf "Error: %s\n" "$1" >&2
    exit 1
}

gocrypt_unique_task_identifier() {
    echo "pass-gocrypt-$(sha256sum <<< "$PREFIX" | cut -d ' ' -f 1)"
}

# This file is used as a lock for all access to the encrypted password store
# so that it prevents the auto-close task from unmounting before all operations
# are completed
gocrypt_lock_file_path() {
    local path="$XDG_RUNTIME_DIR"
    if [ -z "$path" ] || [ ! -d "$path" ]; then
        path="/tmp"
    fi
    echo "$path/$(gocrypt_unique_task_identifier).lck"
}

gocrypt_spawn_close_task() {
    which systemd-run > /dev/null || return

    local task_name="$(gocrypt_unique_task_identifier)"
    # Cancel any previous task that might be present
    systemctl --user stop "$task_name.timer" > /dev/null 2>&1

    # Allow overriding close timeout from env variable
    local timeout=$gocrypt_close_timeout
    if [ ! -z "$PASS_GOCRYPT_CLOSE_TIMEOUT" ]; then
      timeout="$PASS_GOCRYPT_CLOSE_TIMEOUT"
    fi

    # Create a new task
    systemd-run --user --on-active=$timeout --unit="$task_name" \
        /usr/bin/env flock -x "$(gocrypt_lock_file_path)" /usr/bin/env bash -c \
        "fusermount -u '$PREFIX'/'$gocrypt_dec_dir' || fusermount -u -z '$PREFIX'/'$gocrypt_dec_dir'"

    echo "Will close the gocryptfs mount after $timeout seconds"
}

_cmd_git() {
    [ -d '.git' ] && cmd_git "$@"
}

gocrypt_init() {
    local needs_passphrase=false
    local passphrase=""
    while [ $# -gt 0 ]; do
        case "$1" in
            -p|--passphrase)
                needs_passphrase=true
                ;;
            *)
                gocrypt_die "Unexpected argument: $1"
                ;;
        esac
        shift
    done

    [ $# -eq 0 ] || gocrypt_die "Unexpected argument"
    gocrypt_sys_check
    if [ -d "$gocrypt_dir" ] || [ -f "$gocrypt_dir" ]; then
        gocrypt_die "gocrypt plugin already initialized for your password store"
    fi

    if $needs_passphrase; then
        echo -n "Enter passphrase: "
        read -s passphrase
        local passphrase_confirm=""
        echo
        echo -n "Confirm passphrase: "
        read -s passphrase_confirm
        echo
        
        [ "$passphrase" == "$passphrase_confirm" ] || gocrypt_die "Passphrase mismatch"
    fi

    cmd_generate "$gocrypt_passwd_file" 32
    local gocrypt_passwd="$(cmd_show "$gocrypt_passwd_file")"

    # Initialize gocryptfs
    mkdir "$gocrypt_dir"
    if $needs_passphrase; then
        touch "$gocrypt_needs_passphrase_marker"
        gocrypt_passwd="$gocrypt_passwd$passphrase"
    fi
    "$gocryptfs" -passfile /dev/stdin -init "$gocrypt_dir" <<< "$gocrypt_passwd" || gocrypt_die "Unable to initialize gocryptfs"

    # Mount the gocryptfs subdirectory and initialze what is inside of it
    _gocrypt_passwd="$gocrypt_passwd" gocrypt_open || gocrypt_die "Cannot open the gocryptfs we just initialized"
    touch "$gocrypt_dec_dir"/.pass-gocrypt
    # By default, we use the same gpg-id inside, but the user can decide to use a different one later by doing it manually
    ln -s ../.gpg-id "$gocrypt_dec_dir"/.gpg-id

    # Add the decrypted path to gitignore
    echo >> .gitignore
    echo "# Gocrypt" >> .gitignore
    echo "gocrypt" >> .gitignore

    _cmd_git add .gitignore
    $needs_passphrase && _cmd_git add "$gocrypt_needs_passphrase_marker"
    _cmd_git add "$gocrypt_dir"
    _cmd_git commit -m "Initialized encrypted storage for gocrypt plugin"
}

gocrypt_open() {
    [ $# -eq 0 ] || gocrypt_die "Unexpected argument"
    gocrypt_close_check
    mkdir -p "$gocrypt_dec_dir"

    local gocrypt_passwd=""

    if [ ! -z "$_gocrypt_passwd" ]; then
        gocrypt_passwd="$_gocrypt_passwd"
    else
        gocrypt_passwd="$(cmd_show "$gocrypt_passwd_file")"

        if [ -f "$gocrypt_needs_passphrase_marker" ]; then
            local passphrase=""
            echo -n "Enter passphrase: "
            read -s passphrase
            gocrypt_passwd="$gocrypt_passwd$passphrase"
        fi
    fi

    "$gocryptfs" -passfile /dev/stdin "$gocrypt_dir" "$gocrypt_dec_dir" <<< "$gocrypt_passwd" || gocrypt_die "Unable to decrypt"

    gocrypt_spawn_close_task
}

gocrypt_close() {
    [ $# -eq 0 ] || gocrypt_die "Unexpected argument"
    gocrypt_open_check
    # Remove the systemd task for closing if present
    which systemctl > /dev/null && systemctl --user stop "$(gocrypt_unique_task_identifier).timer" > /dev/null 2>&1

    fusermount -u "$gocrypt_dec_dir" || fusermount -u -z "$gocrypt_dec_dir"
}

gocrypt_delegate() {
    # Note: the caller MUST hold the lock for accessing the encrypted password store before calling
    gocrypt_open_check
    # Delegate command to another `pass` instance that manages what is inside of the mountpoint
    PASSWORD_STORE_DIR="$PWD/$gocrypt_dec_dir" "$PROGRAM" "$@"
    # Commit if there has been changes due to this operation
    if [[ `_cmd_git status --porcelain=v1 "$gocrypt_dir"` ]]; then
        _cmd_git add "$gocrypt_dir"
        _cmd_git commit -m "Encrypted pass operation inside gocrypt" "$gocrypt_dir" || echo "No git commit created"
    fi
}

gocrypt_crypt() {
    [ $# -eq 1 ] || gocrypt_die "Unexpected argument"
    gocrypt_open_check
    [ ! -f "$1.gpg" ] && gocrypt_die "Not found: $1"
    cmd_show "$1" | EDITOR=tee gocrypt_delegate edit "$1"
    cmd_delete -f "$1"
    echo "Moved $1 into encrypted storage"
}

gocrypt_help() {
    printf "%s" "\
$PROGRAM gocrypt - hide part of the password store in a subdirectory encrypted with gocryptfs

usage
    $PROGRAM gocrypt init [-p|--passphrase]
        Initialize a encrypted subdirectory at \$PASSWORD_STORE_DIR/$gocrypt_dir. The password used by
        gocryptfs will be generated by pass and stored at \$PASSWORD_STORE_DIR/$gocrypt_passwd_file.gpg.
        The encrypted subdirectory, along with the generated (encrypted) password, will be committed to
        the git repository managed by pass, if there is one.

        By default, the .gpg-id file of the main password store will be symlinked into the encrypted
        subtree. You can change this manually by mounting (opening) the directory and replacing this
        symlink with a custom one.

        You can optionally use an extra piece of symmetric passphrase to encrypt the subdirectory, by
        passing the argument -p or --passphrase when invoking this command to initialize. In this case,
        the passphrase you input will be used along with the generated password to derive the encryption
        key (KEK) of the master key of gocryptfs. This second piece of passphrase will not be stored in
        the password store, and you will be asked for it every time you invoke \`$PROGRAM gocrypt open\`.
        This mode adds an extra layer of protection in case the gpg-encrypted master password is somehow
        compromised.

    $PROGRAM gocrypt open
        Mount the encrypted subdirectory to \$PASSWORD_STORE_DIR/$gocrypt_dec_dir.

    $PROGRAM gocrypt close
        Unmount the encrypted subtree, if it was opened before.

    $PROGRAM gocrypt crypt <pass_name>
        Move a password <pass_name> from the original password store to the encrypted subdirectory. Note
        that if you use git, this will still leave a record in the git repository of the original password
        store.

    $PROGRAM gocrypt help
        Print this help message.

    $PROGRAM gocrypt [ls|list|grep|find|search|show|insert|add|edit|generate|rm|remove|delete|mv|rename|cp|copy|git] ...
        Run the provided subcommand of pass inside the encrypted subtree. This requires that the subdirectory
        has been mounted. When the operation is completed, if the outer password store is a git repository, a
        new commit will be created containing all the encrypted modifications done by the command inside the
        subtree. The commit message will be a generic one and will not leak content inside the subtree.

        You should *always* use this command when modifying the encrypted subtree. If your password store is a
        git repository, operating inside a subtree behind a mountpoint (which is created by gocryptfs) will not
        work properly, and may leak metadata inside the mountpoint.

        TIP: You can create a nested git repository inside the encrypted subtree using \`$PROGRAM gocrypt git ...\`
        commands. This way, any modification in the encrypted subtree will be tracked *both* inside and outside,
        such that the commit inside will contain actual metadata about the modification, and the one outside will be
        encrypted. You will only need to push the repository outside for backup purposes.
"
}

if [ $# -eq 0 ]; then
    gocrypt_help
    exit 1
fi

if [ ! -d "$PREFIX" ]; then
    gocrypt_die "Cannot open password store"
fi

# cd into the password store prefix
cd "$PREFIX"

# Open the lock file
touch "$(gocrypt_lock_file_path)" || exit 1
exec {lock_fd}< "$(gocrypt_lock_file_path)" || exit 1

# Always take the exclusive lock while any command is running -- to prevent the close task from running at the same time
flock -x $lock_fd

case "$1" in
    help)
        gocrypt_help
        exit 0
        ;;
    init)
        shift
        gocrypt_init "$@"
        ;;
    open)
        shift
        gocrypt_open "$@"
        ;;
    crypt)
        shift
        gocrypt_crypt "$@"
        ;;
    close)
        shift
        gocrypt_close "$@"
        ;;
    ls|list|grep|find|search|show|insert|add|edit|generate|rm|remove|delete|mv|rename|cp|copy|git)
        # No shift here since we need to delegate these commands to another pass instance
        gocrypt_delegate "$@"
        ;;
    *)
        gocrypt_die "Unknown command $1 for gocrypt"
esac

# Manual unlock; not strictly necessary since exit will also release the lock
flock -u $lock_fd
