{
  description = "RCloud development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});

    in
      {
        devShells = forAllSystems (pkgs: {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bashInteractive
              cairo
              curl
              icu
              libxcrypt
              libxml2
              nodejs-slim
              nodePackages.npm
              openssl
              pkg-config        # required to build R package Cairo
              redis
              R
              rPackages.codetools
              rPackages.Matrix
              wget
            ];

            # some R packages built by RCloud need to dynamically
            # load openssl, so we must add it to LD_LIBRARY_PATH.
            # This unfortunately may cause other programs not
            # managed by this nix flake to fail if they depend on
            # another version of openssl.
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.openssl ];

            # locale warnings were observed on linux without this
            LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
          };
        });

        overlays.default = final: prev: {};
      };
}
