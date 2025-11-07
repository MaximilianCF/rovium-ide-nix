{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "rovium";
  version = "1.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/MaximilianCF/rovium-ide-nix/releases/download/v${version}/rovium-0.4.0-amd64.deb";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    glib
    nspr
    nss
    cups
    dbus
    gtk3
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    libdrm
    libxkbfile
    libsecret
    mesa
    expat
    alsa-lib
    systemd
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    
    cp -r opt/Rovium $out/opt/
    
    makeWrapper $out/opt/Rovium/rovium $out/bin/rovium \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}"
  '';

  meta = with pkgs.lib; {
    description = "IDE for ROS and Robotics Development";
    platforms = platforms.linux;
  };
}
