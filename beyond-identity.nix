{ lib, stdenv, fetchurl, autoPatchelfHook, libz, libgcc }:
stdenv.mkDerivation {
  name = "beyond-identity";
  src = fetchurl {
    url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/noble/main/b/be/beyond-identity_2.104.0-4/beyond-identity_2.104.0-4_amd64.deb";
    hash = "sha256-lKnDk4lJSawhcl+3jsxmU+oeKaQOnbVwIlIoDX6ZDDU=";
  };

  unpackPhase = ''
    ar x ${./beyond-identity_2.100.2-0_amd64.deb}
  '';

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
    runHook postInstall
  '';
}
