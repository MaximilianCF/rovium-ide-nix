# Rovium IDE (for NixOS)

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org)
[![License: Proprietary](https://img.shields.io/badge/license-unfree-red.svg)](https://rovium.dev)
[![ROS](https://img.shields.io/badge/ROS2-compatible-blue.svg?logo=ros)](https://www.ros.org/)
[![Maintainer](https://img.shields.io/badge/maintainer-MaximilianCF-green.svg)](https://github.com/MaximilianCF)

---

## 📦 Overview

**Rovium** is a modern IDE designed for robotics development, providing native support for **ROS** and **ROS2** environments.  
It is built upon **Electron** and **Eclipse Theia**, offering an extensible and cross-platform interface for robotic projects.

This repository provides a **Nix flake** that repackages the official `.deb` release of Rovium for **NixOS**.

> ⚠️ **Note:** Rovium is proprietary software. This package only provides the Nix expression for reproducible installation — no source code is included or redistributed.

---

## 🚀 Usage

### Clone and run

```bash
git clone https://github.com/MaximilianCF/rovium-ide-nix.git
cd rovium-ide-nix
nix run
```

Or build manually:

```bash
nix build
./result/bin/rovium
```

---

## 🧠 How it works

The flake repackages the official `.deb` release using Nix’s `stdenv.mkDerivation`.

1. Extracts the `.deb` package using `dpkg-deb`
2. Patches ELF binaries automatically via `autoPatchelfHook`
3. Wraps the main binary with `makeWrapper` to fix environment paths
4. Copies the upstream `.desktop` file and icon for integration

---

## ⚙️ Build Details

### Dependencies
Handled automatically through `buildInputs`:
- GTK3 / ATK / Cairo / Pango
- X11 stack (libX11, libXrandr, libxcb, etc.)
- Electron dependencies (NSS, NSPR, libsecret)
- Audio and system (ALSA, dbus, systemd)
- Rendering (mesa, libdrm, libGL)
- Fonts (fontconfig)

### Build Tools
- `autoPatchelfHook` – adjusts runtime library paths
- `makeWrapper` – wraps the Rovium binary with proper env vars
- `dpkg` – extracts `.deb` archive contents

---

## 🪄 Running Options

Rovium runs under both X11 and Wayland.  
In some environments, GPU flags may need adjustment.

```bash
# Force software rendering
LIBGL_ALWAYS_SOFTWARE=1 nix run

# Wayland mode (recommended)
nix run . -- --enable-features=UseOzonePlatform --ozone-platform=wayland
```

---

## ⚠️ Known Warnings (Safe to Ignore)

- `Fontconfig warning: using without calling FcInit()`  
  → benign; can be silenced by ensuring `fontconfig` is in `buildInputs`.

- `Failed to load plugin localization bundles...`  
  → upstream plugin missing translation folders; harmless.

- `Cannot save data: no opened workspace`  
  → normal until a project is opened.

---

## 🧩 License

- **Rovium** itself is proprietary software — [terms on the official website](https://rovium.dev).  
- The **Nix packaging code** in this repository is licensed under **MIT**.

```text
This repository does NOT distribute Rovium binaries.
It only provides a reproducible build recipe that downloads
the original `.deb` package from Rovium's official release page.
```

---

## 🧑‍💻 Maintainer

**Maximilian Canez Fernandes**  
> Backend / NixOS / Robotics / IaC  
> 📍 Pelotas, RS – Brazil  
> 💌 [maximiliancf.dev@icloud.com](mailto:maximiliancf.dev@icloud.com)  
> 🧠 [github.com/MaximilianCF](https://github.com/MaximilianCF)

---

## 🔗 References

- [Rovium Official Website](https://rovium.dev)
- [Rovium GitHub (Beta)](https://github.com/rovium/rovium-beta)
- [ROS / ROS2](https://www.ros.org/)
- [NixOS](https://nixos.org/)
- [Eclipse Theia](https://theia-ide.org/)

---

**Built with ❤️ for the NixOS and ROS communities.**
