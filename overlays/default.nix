{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    qutebrowser = prev.qutebrowser.override {enableWideVine = true;};

    # https://github.com/nix-community/home-manager/issues/3095
    pinentry-rofi = prev.pkgs.writeShellScriptBin "pinentry-rofi" ''
      PATH="$PATH:${prev.pkgs.coreutils}/bin:${prev.pkgs.rofi-wayland}/bin:${prev.pkgs.rofi}/bin"
      "${prev.pinentry-rofi}/bin/pinentry-rofi" "$@"
    '';

   # https://lists.sr.ht/~rjarry/aerc-discuss/%3Ckg5a7r27sb5zqggdbqvnkt63vp5qy45lg5tgrpefcv6kjpww6s@oh4mftaee6bf%3E#%3C6bd4enxmysj4lgfy6jiu3m7iffewgqlgxqrjksygjzn22mqxx4@cly3k6ojcc6k%3E
    aerc = prev.aerc.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [ ./aerc-decrypt-signed-messages.patch ];
    });
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
