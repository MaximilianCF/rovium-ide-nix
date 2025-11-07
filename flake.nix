{
  description = "Rovium IDE — ROS and Robotics Development Environment (Electron + Theia)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # 🧩 Definição local do mantenedor (padrão nixpkgs)
        maintainers = {
          maximiliancf = {
            name = "Maximilian Canez Fernandes";
            email = "maximiliancf.dev@icloud.com";
            github = "MaximilianCF";
          };
        };

        # 🧰 Pacote principal do Rovium
        rovium = pkgs.stdenv.mkDerivation rec {
          pname = "rovium";
          version = "0.4.0-beta";

          src = ./rovium-0.4.0-amd64.deb;

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
            mesa
            libGL
            libxkbfile
            libsecret
            expat
            alsa-lib
            systemd
          ];

          autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

          unpackPhase = ''
            dpkg-deb -x $src .
          '';

          installPhase = ''
            mkdir -p $out/bin $out/opt $out/share/applications

            cp -r opt/Rovium $out/opt/

            # 🧩 Wrapper com libs e flags gráficas
            makeWrapper $out/opt/Rovium/rovium $out/bin/rovium \
              --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}" \
              --set LIBGL_ALWAYS_SOFTWARE 0 \
              --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --no-sandbox"

            # 🖥️ .desktop entry
            cat > $out/share/applications/rovium.desktop <<EOF
            [Desktop Entry]
            Name=Rovium IDE
            Exec=rovium %U
            Icon=$out/opt/Rovium/resources/app.png
            Type=Application
            Categories=Development;IDE;
            EOF
          '';

          dontPatchELF = false;
          dontWrapQtApps = true;

          meta = with pkgs.lib; {
            description = "Rovium IDE — IDE for ROS and Robotics Development";
            homepage = "https://github.com/MaximilianCF/rovium-ide-nix";
            license = licenses.mit;
            platforms = platforms.linux;
            maintainers = with maintainers; [ maximiliancf ];
          };
        };
      in {
        # 📦 Pacote principal
        packages.default = rovium;

        # ▶️ Executável via `nix run`
        apps.default = {
          type = "app";
          program = "${rovium}/bin/rovium";
        };

        # 🧹 Formatter (treefmt padrão)
        formatter = pkgs.nixfmt-rfc-style;
      });
}
