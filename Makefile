.PHONY: 

uname := jacky
domain:= DNixOS
isNixOS:= $(shell cat /etc/os-release | grep -w 'NAME' | grep -q 'NixOS' && echo "TRUE" || echo "FALSE")

gen_ssh:
	ssh-keygen -t rsa -C "18922251299@163.com"

show_ssh:
	cat ~/.ssh/id_rsa.pub

hms:
		@if command -v nix > /dev/null; then \
			nix build .#homeConfigurations."$(uname)@$(domain)".activationPackage && ./result/activate \
		else \
			echo "You should install nix first!"; \
		fi

oss:
		@if [ "$(isNixOS)" = "TRUE" ]; then \
			sudo nixos-rebuild switch --flake .#$(domain); \
		fi

install-nix:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
	# ref: https://github.com/DeterminateSystems/nix-installer

uninstall-nix:
	/nix/nix-installer uninstall
