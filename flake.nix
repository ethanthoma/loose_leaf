{
    inputs = {
        #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:NixOS/nixpkgs/4990d544a76c7dbff98dbbe40c2deb9d3b587588";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, flake-utils, nixpkgs }:

    flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = nixpkgs.legacyPackages.${system};
        in {
            devShells.default = pkgs.mkShell {
                packages = with pkgs; [
                    gleam
                    glas
                    nodejs-slim_21
                ];

                shellHook = '' '';
            };
        }
    );
}
