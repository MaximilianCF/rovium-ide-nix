{
  description = "Rovium IDE — ROS and Robotics Development Environment (Electron + Theia)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # 🧹 Modern formatter (treefmt-nix)
        formatter = treefmt-nix.lib.mkWrapper pkgs { };

        # 🧩 Maintainer info (nixpkgs style)
        maintainers = {
          maximiliancf = {
            name = "Maximilian Canez Fernandes";
            email = "maximiliancf.dev@icloud.com";
            github = "MaximilianCF";
          };
        };

        # 🧰 Main package: Rovium IDE
        rovium = pkgs.stdenv.mkDerivation rec {
          pname = "rovium";
          version = "0.4.0-beta";

          src = ./rovium-0.4.0-amd64.deb;

          # src = pkgs.fetchurl {
          # url = "https://github.com/MaximilianCF/rovium-ide-nix/releases/download/v0.1.0-beta/rovium-0.4.0-amd64.deb";
          # sha256 = "0lar58in784sjc3rnlqafm2bbh9vbl8jrwqwc46g9jhjcgrl6w94";
          # };

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            makeWrapper
            dpkg
          ];

          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            glib
            gtk3
            nspr
            nss
            cups
            dbus
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
            mesa
            libGL
            libxkbfile
            libsecret
            expat
            alsa-lib
            systemd
            fontconfig
          ];

          autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

          unpackPhase = ''
            dpkg-deb -x $src .
          '';

          installPhase = ''
            mkdir -p $out/bin $out/opt $out/share/applications $out/share/icons/hicolor/512x512/apps

            cp -r opt/Rovium $out/opt/

            # 🧩 Wrapper with graphical environment vars
            makeWrapper $out/opt/Rovium/rovium $out/bin/rovium \
              --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}" \
              --set LIBGL_ALWAYS_SOFTWARE 0 \
              --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox"

            # Copy .desktop and icon from the .deb structure
            if [ -f usr/share/applications/rovium.desktop ]; then
              cp usr/share/applications/rovium.desktop $out/share/applications/
            fi

            if [ -d usr/share/icons/hicolor/512x512/apps ]; then
              cp usr/share/icons/hicolor/512x512/apps/* $out/share/icons/hicolor/512x512/apps/
            fi
          '';

          dontPatchELF = false;
          dontWrapQtApps = true;

          meta = with pkgs.lib; {
            description = "Rovium IDE — Integrated Development Environment for ROS and Robotics";
            mainProgram = "rovium";
            homepage = "https://rovium.dev";
            license = licenses.unfreeRedistributable;
            maintainers = with maintainers; [ maximiliancf ];
            platforms = platforms.linux;
            sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          };
        };
      in {
        # 📦 Default package & app entries
        packages.default = rovium;

        apps.default = {
          type = "app";
          program = "${rovium}/bin/rovium";
          meta = {
            description = "Launch Rovium IDE";
            mainProgram = "rovium";
          };
        };

        # 🧹 Formatter (treefmt-nix)
        inherit formatter;
      });
}
