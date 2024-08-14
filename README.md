# dotfiles of lentilus 

## on a new host
On a new machine install nix and build the config with

```bash
nix build "github:lentilus/dotfiles#homeConfigurations.${USER}.activationPackage"
./result/activate
```

## temporary, discreet shell with my home
```bash
nix run "github:lentilus/dotfiles#tmp-shell"
```

## my dotfiles in devcontainers
Bootstrap dotfiles without modifying the devcontainer.json
```bash
devpod up . --dotfiles https://github.com/lentilus/dotfiles.git
```
