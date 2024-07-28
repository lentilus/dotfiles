FROM nixos/nix:latest AS builder

# Copy our source and setup our working dir.
COPY . /dotfiles

# enable flakes
RUN echo "experimental-features = nix-command flakes" >/etc/nix/nix.conf

RUN nix-env --uninstall man-db
RUN nix-env --uninstall git

RUN nix run /dotfiles#tmp-shell -- -U lentilus
# RUN nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# RUN nix-channel --update
# RUN nix-shell '<home-manager>' -A install
# RUN home-manager switch --flake /dotfiles
# RUN which zsh
# RUN ls -al /root

# copy home directory over
# FROM debian:latest
# COPY --from=builder /root /root
# RUN ls -al /root
# RUN ls -al /root/.nix-profile

# ENTRYPOINT ["/root/.nix-profile/bin/zsh"]
