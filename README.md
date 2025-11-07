# Rovium IDE (for NixOS)

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org)
[![License: Proprietary](https://img.shields.io/badge/license-unfree-red.svg)](https://rovium.dev)
[![ROS](https://img.shields.io/badge/ROS2-compatible-blue.svg?logo=ros)](https://www.ros.org/)
[![Maintainer](https://img.shields.io/badge/maintainer-MaximilianCF-green.svg)](https://github.com/MaximilianCF)

---

## 📦 Overview

**Rovium** is a modern IDE for robotics development with **ROS** and **ROS2**.  
It is built with **Electron** and **Eclipse Theia**, providing an extensible, cross-platform interface for robotics projects.

This repository provides a **Nix flake** that repackages the official `.deb` release of Rovium for **NixOS**.

> ⚠️ **Note:** Rovium is proprietary software.  
> This repository only provides the Nix expression and does not redistribute the binary.

---

## 🚀 Usage

Clone and run directly:

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

1. Extracts the `.deb` using `dpkg-deb`
2. Automatically patches ELF binaries via `autoPatchelfHook`
3. Wraps the executable with correct library paths
4. Installs the `.desktop` entry and icon for integration

---

## ⚙️ Build Details

### Dependencies
Handled automatically through `buildInputs`:
- GTK3 / ATK / Cairo / Pango
- X11 stack (libX11, libXrandr, libxcb, etc.)
- Electron runtime (NSS, NSPR, libsecret)
- Audio (ALSA) and system libraries (dbus, systemd)
- Rendering (mesa, libdrm, libGL)
- Fonts (fontconfig)

### Build Tools
- `autoPatchelfHook` – fixes ELF runtime paths  
- `makeWrapper` – wraps the Rovium binary  
- `dpkg` – extracts `.deb` archives  

---

## 🪄 Running Options

Rovium runs under both X11 and Wayland.  
In some systems, GPU flags may require tweaking:

```bash
# Force software rendering
LIBGL_ALWAYS_SOFTWARE=1 nix run

# Wayland mode (recommended)
nix run . -- --enable-features=UseOzonePlatform --ozone-platform=wayland
```

---

## 🧹 Formatting

The project uses [`treefmt-nix`](https://github.com/numtide/treefmt-nix) with `nixfmt-rfc-style` and other formatters.

Run:
```bash
nix fmt
```

Configuration lives in [`treefmt.toml`](./treefmt.toml).

---

## 🧩 License

- **Rovium** itself is proprietary software — see [rovium.dev](https://rovium.dev).  
- The **Nix packaging code** is licensed under MIT.

```text
This repository does NOT distribute Rovium binaries.
It only provides a reproducible build recipe for NixOS users.
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
- [treefmt-nix](https://github.com/numtide/treefmt-nix)

---

**Built with ❤️ for the NixOS and ROS communities.**
