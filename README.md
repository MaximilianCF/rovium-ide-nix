# Rovium IDE for NixOS

[![Built with Nix](https://img.shields.io/badge/Built%20with-Nix-blue?style=flat&logo=nixos&logoColor=white)](https://nixos.org)
[![License: unfreeRedistributable](https://img.shields.io/badge/license-unfree--redistributable-red)](#license)
[![Platform: Linux](https://img.shields.io/badge/platform-linux-green?logo=linux)](#compatibility)

**Rovium** is an integrated development environment (IDE) for robotics and ROS (Robot Operating System) development, built on **Electron** and **Eclipse Theia**.

This flake repackages the official `.deb` release of Rovium for seamless use on NixOS and other Nix-based systems.

---

## Features

- 🧩 **Native ROS integration** (workspaces, catkin/colcon, RViz, Gazebo)
- 💻 **Modern Theia-based interface** (VSCode-like experience)
- 🛠️ **Declarative and reproducible** development environment via Nix
- 🧱 **Electron-based**, packaged as an isolated graphical application

---

## Installation

### Run directly
```bash
nix run github:MaximilianCF/rovium-ide-nix
```

### Build locally
```bash
git clone https://github.com/MaximilianCF/rovium-ide-nix.git
cd rovium-ide-nix
nix build
./result/bin/rovium
```

### Format the flake
```bash
nix fmt
```

---

## Technical Details

- **Base:** Electron + Eclipse Theia
- **Version:** `0.4.0-beta`
- **Packaging:** `stdenv.mkDerivation` extracting official `.deb` via `dpkg-deb`
- **Graphics:** X11 (with Wayland support via Ozone)
- **Runtime flags:**
  ```bash
  --no-sandbox --ozone-platform=x11
  --disable-update --disable-component-update
  --disable-breakpad --enable-features=UseOzonePlatform
  ```

The generated wrapper at `${out}/bin/rovium` automatically sets required environment variables for Nix sandbox execution:

```bash
LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
ELECTRON_NO_UPDATER=1
```

---

## Compatibility

| Platform | Status |
|----------|---------|
| Linux (x86_64) | ✅ Supported |
| macOS (aarch64/x86_64) | ⚠️ Untested |
| Windows | ❌ Not supported |

---

## Project Structure

```
rovium-ide-nix/
├── flake.nix        # Main package definition
├── treefmt.toml     # Nix formatting configuration
└── README.md        # This file
```

---

## Future Roadmap

- [ ] ROS2 support (Humble, Jazzy)
- [ ] Enhanced colcon/catkin workspace integration
- [ ] VSCode-compatible extensions
- [ ] Build from source (currently repackages binary)

---

## Maintainer

**Maximilian Canez Fernandes**  
📧 maximiliancf.dev@icloud.com  
🔗 [GitHub — @MaximilianCF](https://github.com/MaximilianCF)

---

## License

Distributed under **`unfreeRedistributable`** (non-free, redistribution permitted).

This package does **not contain modified source code** — it solely redistributes the official `.deb` binary for integration with the Nix ecosystem.

---

## Credits

- Based on **Eclipse Theia** and **Electron**
- Packaged for Nix by [@MaximilianCF](https://github.com/MaximilianCF)
- Rovium IDE © Rovium Dev Team (2025)
