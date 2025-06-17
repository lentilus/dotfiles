{
  stdenv,
  fetchFromGitHub,
  gocryptfs,
  pass_gocrypt_timeout ? 300,
}:
stdenv.mkDerivation {
  pname = "pass-gocrypt";
  version = "44bed1e";
  src = fetchFromGitHub {
    owner = "lentilus";
    repo = "pass-gocrypt";
    rev = "44bed1e";
    sha256 = "sha256-8MnF6fV7xdQeNpx4AATQGkYpzeq7ecURMjIx8q0yV3k=";
  };

  buildInputs = [gocryptfs];

  buildPhase = ''
    chmod +x gocrypt.bash
  '';

  installPhase = ''
    mkdir -p $out/lib/password-store/extensions/
    cp gocrypt.bash $out/lib/password-store/extensions/gocrypt.bash
  '';

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/gocrypt.bash \
      --replace 'readonly gocryptfs="gocryptfs"' 'readonly gocryptfs="${gocryptfs}/bin/gocryptfs"'
    substituteInPlace $out/lib/password-store/extensions/gocrypt.bash \
      --replace 'readonly gocrypt_close_timeout="300"' 'readonly gocrypt_close_timeout="${pass_gocrypt_timeout}"' '';
}
