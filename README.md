# lentilus dotfiles

This repository includes my entire working-environment managed in a
`nix flake` with the help of `nixos` and `home-manager`.
For secrets management I use `sops` with `sops-nix`.

Using the power of `proot` my shell environment can be temporarily used on
any machine that has nix installed by running the following.
```nix
HOME=/tmp/my-tmp-home nix run github:lentilus/dotfiles#shell --impure -- zsh
```
In fact, you can safely try that on your own machine. You can
look at `./proot-shell.nix` to see what it does.

# Protocol

## Renewing GPG Subkeys

- _Renew every year_
- _Rotate when the algorithm changes_

Spin up `https://github.com/dhess/nixos-yubikey`.
Insert the backup thumb drive.
```bash
# restore the keystore from the backup
gpg-backup-restore-keys /dev/backup-drive
gpg -Kv

# renew the keys
gpg-renew-subkeys
gpg> key 1
gpg> key 2
gpg> key 3

gpg> expire
# ... 1y
gpg> save

# backup changes
cd $GNUPGHOME
git add .
git commit -m "renew subkeys"
gpg-backup-sync-keys /dev/backup-drive

# put updated public key on some portable thumb drive
gpg --armor --export-options export-minimal --export > /path/to/portable/pubkey.asc
```

Now update the key everywhere.
- ./hosts/T480/publickey.asc
- github.com
- mailbox.org

