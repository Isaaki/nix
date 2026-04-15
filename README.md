# NixOS Configuration

## Structure

```text
.
├── flake.nix               # Main entry point (Pins nixpkgs and home-manager)
├── GEMINI.md               # Context for the Gemini AI agent
├── setup.sh                # Initial setup script for user identity
│
├── hosts/                  # System-level configuration (Root/Sudo)
│   ├── shared/             # Common modules (firefox, docker, cachix, etc.)
│   ├── megalo/             # Host-specific settings (Main PC)
│   ├── hadro/              # Host-specific settings (Work PC)
│   └── tarcho/             # Host-specific settings (Surface Laptop)
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
    git clone https://github.com/Isaaki/nix.git ~/nix
    cd ~/nix
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
    For the first run, use standard Nix:
    ```bash
    sudo nixos-rebuild switch --flake .#nixos-<hostname>
    ```

## Management Commands

Run these from the project root after the initial install:

- `nh os switch`: Rebuild and apply the system configuration.
- `nh os switch -u`: Update flake lockfile and apply system updates.
- `nh clean all`: Smarter garbage collection (keeps recent backups).

## Cross-Compiling for Surface (Tarcho)

To avoid compiling the `linux-surface` kernel on the laptop itself, use a faster machine (e.g., `megalo`) to build and push to Cachix.

### 1. On the Fast Machine (e.g., Megalo)
Ensure you are authenticated with Cachix and have `jq` installed.

```bash
# Build the Tarcho system (including the kernel)
nix build --json .#nixosConfigurations.nixos-tarcho.config.system.build.toplevel \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push nix-isaaki
```

### 2. On the Surface Laptop (Tarcho)
Simply apply the configuration. It will automatically detect and pull the pre-built binaries from your Cachix cache.

```bash
nh os switch
```

*Note: As long as the `flake.lock` is identical on both machines, the Surface will download the binaries instead of compiling.*
