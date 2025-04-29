{
  description = "RCloud development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, zig, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          zig.overlays.default
        ];

        pkgs = import nixpkgs {
          overlays = overlays;
          system = system;
        };

      in
        {
          overlays = overlays;

          devShells.default =
            pkgs.mkShell {
              buildInputs = with pkgs; [
                # autoconf
                # automake
                bashInteractive
                cairo
                curl
                killall
                git
                # gnumake
                gettext
                icu
                libxcrypt
                libxml2
                # nodejs-slim
                # nodePackages.npm
                openssl
                pkg-config
                redis
                R
                rPackages.codetools
                rPackages.Matrix
                wget
                zig.packages.${system}."0.14.0"
              ];

              LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl gettext ];
              LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
            };

        });
}
