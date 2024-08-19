let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
in
pkgs.mkShell {
  packages = with pkgs; [
    autoconf
    automake
    cairo
    curl
    killall
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
  ];

  LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
