#!/usr/bin/env bash

# Exit on error
set -e

echo "=== NixOS Config Setup ==="

# 1. Ask for Git Identity (Dox-proof)
if [ ! -f ~/.gitconfig ]; then
    echo "Creating ~/.gitconfig..."
    read -p "Enter your Full Name: " GIT_NAME
    read -p "Enter your Email: " GIT_EMAIL

    cat <<EOF > ~/.gitconfig
[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
EOF
    echo "Identity saved to ~/.gitconfig"
else
    echo "Identity file already exists at ~/.gitconfig"
fi

# 2. Extract host definition keys reliably from flake.nix
echo ""
echo "Identifying available hosts..."
# Look for nixosConfigurations = { ... } block
HOSTS=$(grep -E 'nixos-[a-zA-Z0-9_-]+[[:space:]]*=' flake.nix | sed -E 's/^[[:space:]]*(nixos-[a-zA-Z0-9_-]+).*/\1/')

if [ -z "$HOSTS" ]; then
    echo "ERROR: No hosts found in flake.nix!"
    exit 1
fi

echo "Available configurations:"
select SELECTED_HOST in $HOSTS "Quit"; do
    if [ "$SELECTED_HOST" = "Quit" ]; then
        exit 0
    elif [ -n "$SELECTED_HOST" ]; then
        break
    else
        echo "Invalid option $REPLY"
    fi
done

echo ""
echo "=== Setup Complete ==="
echo "Selected Host: $SELECTED_HOST"
echo ""
echo "NEXT STEPS:"
echo "1. To apply this configuration for the FIRST time, run:"
echo ""
echo "  sudo nixos-rebuild switch --flake .#$SELECTED_HOST"
echo ""
echo "2. For future updates, use the 'nh' tool:"
echo ""
echo "  nh os switch"
echo ""
