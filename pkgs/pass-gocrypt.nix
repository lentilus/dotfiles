{
  stdenv,
  gocryptfs,
  pass_gocrypt_timeout ? 300,
}:
stdenv.mkDerivation {
  pname = "pass-gocrypt";
  version = "44bed1e";
  src = ./pass-gocrypt.sh;
  dontUnpack = true;
  buildInputs = [gocryptfs];

  buildPhase = ''

  '';

  installPhase = ''
    mkdir -p $out/lib/password-store/extensions/
    cp $src $out/lib/password-store/extensions/gocrypt.bash
    chmod +x $out/lib/password-store/extensions/gocrypt.bash
  '';

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/gocrypt.bash \
      --replace 'readonly gocryptfs="gocryptfs"' 'readonly gocryptfs="${gocryptfs}/bin/gocryptfs"'
    substituteInPlace $out/lib/password-store/extensions/gocrypt.bash \
      --replace 'readonly gocrypt_close_timeout="300"' 'readonly gocrypt_close_timeout="${pass_gocrypt_timeout}"' '';
}
