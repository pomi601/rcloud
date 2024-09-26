{
  description = "RCloud development with Zig build";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, zig, zls, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # this overrides zls to skip checks, because their things sometimes fail
        zlsOverlay = final: prev: {
          zlsOverride = zls.packages.${system}.zls.overrideAttrs { doCheck = false; };
        };

        overlays = [
          zig.overlays.default
          zlsOverlay
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
                icu
                libxcrypt
                libxml2
                nodejs-slim
                nodePackages.npm
                openssl
                pkg-config
                redis
                R
                rPackages.codetools
                rPackages.Matrix

                zig.packages.${system}.master
                zlsOverride
              ];

              LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl ];
              LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
            };

          devShells.stable =
            pkgs.mkShell {
              buildInputs = with pkgs; [
                bashInteractive
                cairo
                curl
                killall
                git
                icu
                libxcrypt
                libxml2
                nodejs-slim
                nodePackages.npm
                openssl
                pkg-config
                redis
                R
                rPackages.codetools
                rPackages.Matrix
                pkgs.zig
                pkgs.zls
              ];

              LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl ];
              LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
            };
        });
}
