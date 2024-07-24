let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
  pkgsUnstable = import <nixpkgs-unstable> { config = {}; overlays = [  ]; };
in
pkgs.mkShell {
  packages = with pkgs; [
    autoconf
    automake
    cairo
    curl
    git
    gnumake
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
    wget
  ] ++ (with pkgsUnstable; [
    zig
  ]);

  LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
