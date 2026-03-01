{
  python310Packages,
  python310,
  pkg-config,
  gpgme,
}:

let
  pygpgme-fixed = python310Packages.pygpgme.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkg-config ];
    buildInputs       = (old.buildInputs       or []) ++ [ gpgme ];
  });
in

python310Packages.buildPythonApplication rec {
  pname = "pgpmime-decrypt";
  version = "1.1";
  pyproject = false;
  python = python310;

  propagatedBuildInputs = [
    pygpgme-fixed
  ];

  dontUnpack = true;
  installPhase = ''
    install -Dm755 "${./pgpmime-decrypt.sh}" "$out/bin/${pname}"
  '';
}
