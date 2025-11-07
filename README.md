# Rovium for NixOS

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Made with ❤️ in Brazil](https://img.shields.io/badge/Made%20with%20%E2%9D%A4%EF%B8%8F%20in-Brazil-green)](https://en.wikipedia.org/wiki/Brazil)

Nix package for [Rovium](https://rovium.dev) - The IDE for ROS and Robotics Development.

> ⚠️ **Beta Software**: Rovium is currently in beta. This package may require updates as the software evolves.

## About

Rovium is a modern IDE specifically designed for robotics development with ROS (Robot Operating System). This repository provides a Nix derivation to package the official `.deb` release for NixOS users.

## Installation

### Using `nix-build`
```bash
git clone https://github.com/MaximilianCF/rovium-ide-nix.git
cd rovium-nix
nix-build
./result/bin/rovium
```

### Using `nix-env`
```bash
nix-env -if .
rovium
```

### In your NixOS configuration
```nix
{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.callPackage /path/to/rovium-nix/default.nix {})
  ];
}
```

### As a flake (planned)
```nix
{
  inputs.rovium-nix.url = "github:maxmartinsjr/rovium-nix";
  
  outputs = { self, nixpkgs, rovium-nix }: {
    # Use in your configuration
  };
}
```

## Requirements

- NixOS or Nix package manager
- Rovium `.deb` file (currently requires manual download)
- X11 or Wayland display server

## How it works

This package:
1. Extracts the official Rovium `.deb` archive
2. Uses `autoPatchelfHook` to automatically patch ELF binaries
3. Resolves all necessary dependencies (GTK3, X11, etc.)
4. Creates a wrapped executable with proper library paths

## Dependencies

The package automatically handles these runtime dependencies:
- GTK3 and friends (atk, cairo, pango)
- X11 libraries
- NSS/NSPR (for Chromium/Electron base)
- libsecret (keyring integration)
- ALSA (audio support)
- And many more...

## Technical Details

- **Base**: Electron-based application
- **Packaging method**: Binary repackaging with `autoPatchelfHook`
- **Ignored deps**: `libc.musl-x86_64.so.1` (optional serialport dependency)

## Known Issues

- Musl libc dependency from serialport module is ignored (doesn't affect core functionality)
- Desktop integration files need manual setup (planned improvement)

## Contributing

Contributions are welcome! If you find issues or have improvements:

1. Fork the repository
2. Create a feature branch
3. Test your changes with `nix-build`
4. Submit a pull request

## Future Plans

- [ ] Convert to flake-based package
- [ ] Add desktop entry and icon integration  
- [ ] Submit to nixpkgs upstream (when Rovium reaches stable release)
- [ ] Add update script for automatic version bumps
- [ ] Test on different NixOS configurations

## Background

This package was created as a personal project while diving into ROS2 and robotics with NixOS. The goal is to contribute to the intersection of declarative systems and robotics development, making modern robotics tools accessible to the Nix community.

## License

This packaging code is licensed under the MIT License - see [LICENSE](LICENSE) file.

**Note**: Rovium itself is proprietary software. This repository only contains the Nix packaging code, not the Rovium software. Please refer to Rovium's official license terms.

## Links

- [Rovium Official Website](https://rovium.dev)
- [ROS](https://www.ros.org/)
- [NixOS](https://nixos.org/)

## Author

**Maximilian Canez Fernandes**
- Backend / Debian / NixOS / Iac / Robotics
- Location: Pelotas, RS, Brazil

---

*Built with ❤️ for the NixOS and ROS communities*