# NixOS Configuration

## Structure

```text
.
├── flake.nix               # Main entry point (Pins nixpkgs and home-manager)
├── Makefile                # Shortcuts for system management
├── setup.sh                # Initial setup script for user identity
│
├── hosts/                  # System-level configuration (Root/Sudo)
│   └── <hostname>/         # Host-specific settings (e.g., megalo, hadro)
│       ├── configuration.nix
│       └── hardware-configuration.nix
│
└── home/                   # User-level configuration (Home Manager)
    └── shared/
        └── home.nix        # Shared application list and user settings
```

## Installation Workflow (Graphical)

1.  **Run Graphical Installer**:
    - Boot the NixOS ISO.
    - Choose the "Graphical Install".
    - **Crucial**: Create your user with the same username defined in `flake.nix` for that host.
    - Reboot into your new system.

2.  **Clone & Prepare**:

    ```bash
    git clone <your-repo-url> ~/dev/nix
    cd ~/dev/nix
    ```

3.  **User Identity**:
    Run the setup script to generate `~/.gitconfig`:

    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

4.  **Detect Physical Hardware**:
    Capture your system's specific partition UUIDs:

    ```bash
    nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
    git add .
    ```

5.  **Initial Apply**:
    ```bash
    sudo nixos-rebuild switch --flake .#<hostname>
    ```

## Management Commands

Run these from the project root after the initial install:

- `make apply`: Rebuild and switch to the configuration (auto-detects hostname).
- `make update`: Update the flake lockfile and apply system-wide updates.
- `make clean`: Collect garbage and remove old generations.
