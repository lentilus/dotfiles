{
  config,
  lib,
  pkgs,
  ...
}: let
  # Default paths for source and target directories.
  defaultSourceDir = ./config;
  defaultTargetDir = ".config";

  # Helper to process each enabled target.
  generateEntries = targets: sourceDir: targetDir:
    lib.flatten (lib.attrsets.mapAttrsToList (
        name: target:
          lib.mkIf target.enable {
            "${targetDir}/${name}" =
              lib.attrsets.overrideAttrs (_: {
                source = builtins.toPath "${sourceDir}/${name}";
              })
              target.options;
          }
      )
      targets);
in {
  # Define global options for the source and target directories.
  options.home.config.sourceDir = {
    type = lib.types.path;
    default = defaultSourceDir;
    description = "Path to the source directory containing configuration files.";
  };

  options.home.config.targetDir = {
    type = lib.types.str;
    default = defaultTargetDir;
    description = "Path to the target directory relative to the home directory.";
  };

  # Define options for individual targets.
  options.home.config.targets = lib.types.attrsOf (lib.types.submodule {
    options.enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable copying this specific configuration.";
    };

    options.options = {
      type = lib.types.attrs;
      default = {};
      description = "Additional options to pass to home.file for this target.";
    };
  });

  config = let
    sourceDir = config.home.config.sourceDir;
    targetDir = config.home.config.targetDir;
    targets = config.home.config.targets;
  in {};
  # lib.mkIf (!lib.attrsets.isEmpty targets) {
  #   home.file = lib.attrsets.fromList (generateEntries targets sourceDir targetDir);
  # };
}
