{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    qutebrowser = prev.qutebrowser.override {enableWideVine = true;};

    # https://github.com/nix-community/home-manager/issues/3095
    pinentry-rofi = prev.pkgs.writeShellScriptBin "pinentry-rofi" ''
      PATH="$PATH:${prev.pkgs.coreutils}/bin:${prev.pkgs.rofi-wayland}/bin:${prev.pkgs.rofi}/bin"
      "${prev.pinentry-rofi}/bin/pinentry-rofi" "$@"
    '';
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };
}
