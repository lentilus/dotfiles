{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl

    lean4
    unstable.typst
    unstable.go

    # python
    poetry
    pyenv
    pipx
  ];
}
