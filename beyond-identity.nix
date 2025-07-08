{ lib, binutils, stdenv, fetchurl, autoPatchelfHook, libz, libgcc }:
let
  version = "2.104.0-4";
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "beyond-identity-unwrapped";
  src = fetchurl {
    name = "beyond-identity_${version}_amd64";
    url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/noble/main/b/be/beyond-identity_2.104.0-4/beyond-identity_${version}_amd64.deb";
    # hash = lib.fakeHash;
    hash = "sha256-BeB8/O0/0EijD7jQ984yB2/QgW1NpKdpTpw/Mptc+C4=";
    # hash = "sha256-lKnDk4lJSawhcl+3jsxmU+oeKaQOnbVwIlIoDX6ZDDU=";
    recursiveHash = true;
    downloadToTemp = true;
    postFetch = ''
      mkdir $out
      cd $out
      ${binutils}/bin/ar x $downloadedFile
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libz
    libgcc
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    tar xf ./data.tar.gz -C $out
    mv $out/usr/bin $out/bin
    runHook postInstall
  '';
}
