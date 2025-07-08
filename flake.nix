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
          pname = "beyond-identity";
          version = self.packages.${system}.authenticator.version;
          targetPkgs = pkgs: ([
            self.packages.${system}.authenticator
          ]);
          runScript = "${self.packages.${system}.authenticator}/bin/beyond-identity";
        };

      packages.authenticator = pkgs.callPackage ./beyond-identity.nix { };

      devShells.default = with pkgs; mkShell {
        inputsFrom = [ self.packages.${system}.default ];
      };
    });
}
