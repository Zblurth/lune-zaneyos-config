# Project Overview

This repository contains ZaneyOS, a comprehensive NixOS configuration. It aims to provide a fully-featured, customizable desktop environment based on NixOS, with a focus on aesthetics and usability. The configuration is built around the Hyprland window manager and includes a wide range of pre-configured applications and tools.

The project is structured using Nix Flakes, with a clear separation of concerns between system-level modules, home-manager modules for user-specific configurations, and host-specific settings. This allows for a high degree of modularity and reusability.

## Building and Running

ZaneyOS is a NixOS configuration and is not "built" in the traditional sense. Instead, you "rebuild" your NixOS system to apply the configuration.

The primary way to manage the system is through the `nixos-rebuild` command. The `flake.nix` file defines several NixOS configurations, each corresponding to a different GPU profile (e.g., `amd`, `nvidia`, `intel`, `vm`).

To apply the configuration for a specific profile, you would use a command like this:

```bash
sudo nixos-rebuild switch --flake .#<profile>
```

For example, to apply the `amd` profile, you would run:

```bash
sudo nixos-rebuild switch --flake .#amd
```

The `README.md` file provides detailed instructions for installation and upgrading.

## Development Conventions

The project follows standard Nix conventions. The code is organized into modules, and the configuration is managed through the `flake.nix` file.

-   **System Configuration:** System-level configurations are located in the `modules/core` directory.
-   **User Configuration:** User-specific configurations are managed by home-manager and are located in the `modules/home` directory.
-   **Host Configuration:** Host-specific configurations, including hardware settings and customizable variables, are located in the `hosts` directory. Each host has its own subdirectory, and the `variables.nix` file within that directory is the primary entry point for customization.
-   **Profiles:** The `profiles` directory contains configurations for different hardware profiles, primarily for different GPU vendors.

The project encourages customization through the `variables.nix` file in each host's directory. This file allows you to enable or disable features, set themes, and configure applications without directly modifying the core modules.
