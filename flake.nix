{
  description = "Source-only MoonBit Workgraph workspace with same-source wasm/native CLI adapters";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    moonbit-overlay = {
      url = "github:totto2727/moonbit-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, moonbit-overlay, ... }:
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
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              # One MoonBit toolchain checks and builds both declared CLI adapter targets.
              pkgs.moonbit-bin.moonbit.latest
              # Retained for the workspace modules that also declare JavaScript support.
              pkgs.nodejs_24
            ];
          };
        });
    };
}
