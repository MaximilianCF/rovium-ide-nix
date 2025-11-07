# Rovium for NixOS (Flake Edition)

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org)  
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
[![Made with ❤️ in Brazil](https://img.shields.io/badge/Made%20with%20%E2%9D%A4%EF%B8%8F%20in-Brazil-green)](https://en.wikipedia.org/wiki/Brazil)

> 🧠 **IDE for ROS & Robotics Development**, packaged declaratively for NixOS.

---

## 🧩 Overview

**Rovium** is a modern IDE built for robotics development, with first-class support for ROS (Robot Operating System).  
This repository provides a **flake-based Nix package** for the official Rovium `.deb` release, ensuring full reproducibility and isolation for NixOS and Nix users.

> ⚠️ **Note:** Rovium is currently in beta. Minor updates to the `.deb` package may require small adjustments to the Nix expression.

---

## 🚀 Installation

### 1. **Clone and run directly**
```bash
git clone https://github.com/MaximilianCF/rovium-ide-nix.git
cd rovium-ide-nix
nix run
```

This will build and run Rovium directly from the flake.

---

### 2. **Build manually**
```bash
nix build
./result/bin/rovium
```

---

### 3. **Install permanently**
```bash
nix profile install github:MaximilianCF/rovium-ide-nix
rovium
```

---

### 4. **Use inside your NixOS configuration**

```nix
{
  inputs.rovium.url = "github:MaximilianCF/rovium-ide-nix";

  outputs = { self, nixpkgs, rovium, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = [ rovium.packages.x86_64-linux.default ];
        }
      ];
    };
  };
}
```

---

## ⚙️ How it works

The flake automatically:
1. Extracts the official `.deb` file with `dpkg-deb`
2. Uses `autoPatchelfHook` to patch ELF binaries
3. Resolves all GTK3, X11, and Electron dependencies
4. Wraps the Rovium executable with proper `LD_LIBRARY_PATH`
5. Adds a `.desktop` entry for menu integration

---

## 🧠 Dependencies handled automatically

- **GTK3 stack**: atk, cairo, pango, etc.  
- **X11**: libX11, libXcomposite, libXrandr, etc.  
- **Electron stack**: nss, nspr, libsecret  
- **Audio & system**: alsa-lib, dbus, systemd  
- **Rendering**: mesa, libdrm, libGL  

---

## 🪄 Commands summary

| Command | Description |
|----------|-------------|
| `nix run` | Run Rovium directly |
| `nix build` | Build the package only |
| `nix profile install` | Install system-wide |
| `nix flake show` | Inspect flake outputs |

---

## 🧩 Technical Details

- **Base:** Electron + Theia  
- **Build type:** Binary repackaging (no source rebuild)  
- **Tooling:** `autoPatchelfHook`, `makeWrapper`, `dpkg`  
- **Ignored dep:** `libc.musl-x86_64.so.1` (used by optional serialport module)

---

## ⚙️ Quick Debug / GPU & Wayland Notes

Rovium runs fine in both **X11** and **Wayland**.  
If you encounter rendering or GPU-related warnings, try one of the following:

### 🧩 Force software rendering
```bash
LIBGL_ALWAYS_SOFTWARE=1 nix run
```

### 🧩 Enable full GPU acceleration
```bash
nix run . -- --enable-gpu --use-gl=desktop
```

### 🧩 Wayland support (recommended for GNOME / Sway / KDE Plasma)
```bash
nix run . -- --enable-features=UseOzonePlatform --ozone-platform=wayland
```

If running over SSH or without a GPU, you can safely ignore VSync warnings such as:
```
ERROR:ui/gl/gl_surface_presentation_helper.cc:260] GetVSyncParametersIfAvailable() failed
```

---

## ⚠️ Known Issues

- First launch creates configuration in `~/.rovium/`
- Minor `VSync`/`GL` warnings may appear on systems without GPU acceleration
- Missing localization folders in the Python plugin (`KylinIdeTeam.kylin-python`) are harmless

---

## 🧩 Future Plans

- [x] Migrate from `default.nix` to `flake.nix` ✅  
- [x] Add `.desktop` integration ✅  
- [ ] Automate `.deb` fetching from GitHub Releases  
- [ ] Multi-arch support (aarch64 / ARM)  
- [ ] Publish to `nixpkgs` upstream  

---

## 🤝 Contributing

Contributions are welcome!  
1. Fork the repo  
2. Create a feature branch  
3. Test with `nix run`  
4. Submit a pull request  

---

## 🧑‍💻 Author

**Maximilian Canez Fernandes**  
> Backend • NixOS • Robotics • IaC  
> 📍 Pelotas, RS — Brazil  
> 💌 [maximiliancf.dev@icloud.com](mailto:maximiliancf.dev@icloud.com)  
> 🧠 [github.com/MaximilianCF](https://github.com/MaximilianCF)

---

## 📜 License

This packaging is under the **MIT License**.  
See [LICENSE](LICENSE) for details.

> ⚠️ *Rovium itself is proprietary software.*  
> This repository only provides the Nix packaging code, not the Rovium binaries.

---

## 🔗 Links

- [Rovium Official Website](https://rovium.dev)  
- [ROS](https://www.ros.org/)  
- [NixOS](https://nixos.org/)  

---

**Built with ❤️ for the NixOS and ROS communities**
