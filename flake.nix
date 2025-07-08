{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {

      packages.default = pkgs.buildFHSEnv
        {
          name = "beyond-identity-wrap";
          targetPkgs = pkgs: ([
            self.packages.${system}.authenticator
          ]);
          # runScript = "${self.packages.${system}.authenticator}/usr/bin/beyond-identity";
          runScript = "bash";
        };

      packages.authenticator = pkgs.callPackage ./beyond-identity.nix { };

      devShells.default = with pkgs; mkShell {
        inputsFrom = [ self.packages.${system}.default ];
      };

    });
}
