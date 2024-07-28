{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    foo = lib.mkOption {
      default = "hello";
    };
  };

  config = {
    home.file."hohohaha".text = "${config.foo}";
  };
}
