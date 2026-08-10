{
  description = "Source-only six-module MoonBit Workgraph workspace";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    moonbit-overlay = {
      url = "github:totto2727/moonbit-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, moonbit-overlay }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [ moonbit-overlay.overlays.default ];
      };
      mkSourcePackage = pkgs:
        pkgs.stdenvNoCC.mkDerivation {
          pname = "workgraph";
          version = "0.1.3";
          src = self;
          installPhase = ''
            mkdir -p "$out/share/workgraph"
            cp -R package moon.work README.md LICENSE "$out/share/workgraph/"
          '';
        };
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.just
              pkgs.moonbit-bin.moonbit.latest
            ];
          };
        });

      packages = forEachSystem (system:
        let
          pkgs = mkPkgs system;
          workgraph = mkSourcePackage pkgs;
        in
        {
          inherit workgraph;
          default = workgraph;
        });

      overlays.default = final: prev: {
        workgraph = self.packages.${final.stdenv.hostPlatform.system}.workgraph;
      };
    };
}
