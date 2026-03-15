# Simple Makefile for NixOS management

.PHONY: apply update clean

# Detect hostname and strip 'nixos-' prefix to match flake keys (e.g., 'nixos-megalo' -> 'megalo')
HOST ?= $(shell hostname | sed 's/nixos-//')

apply:
	sudo nixos-rebuild switch --flake .#$(HOST)

update:
	nix flake update
	sudo nixos-rebuild switch --flake .#$(HOST)

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
