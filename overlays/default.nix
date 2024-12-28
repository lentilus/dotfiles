{inputs, ...}: {
  # additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    qutebrowser = prev.qutebrowser.override {enableWideVine = true;};
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
