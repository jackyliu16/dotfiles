.PHONY: 

uname := jacky
domain:= DNixOS
isNixOS:= $(shell cat /etc/os-release | grep -w 'NAME' | grep -q 'NixOS' && echo "TRUE" || echo "FALSE")
substituter ?= --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"
extra_command ?= --extra-experimental-features flakes --extra-experimental-features nix-command 

gen_ssh:
	ssh-keygen -t rsa -C "18922251299@163.com"

show_ssh:
	cat ~/.ssh/id_rsa.pub | curl -F "c=@-" "https://fars.ee/"

hms:
		@if command -v nix > /dev/null; then \
			nix build .#homeConfigurations."$(uname)@$(domain)".activationPackage $(substituter) && ./result/activate \
		else \
			echo "You should install nix first!"; \
		fi

oss:
		@if [ "$(isNixOS)" = "TRUE" ]; then \
			sudo nixos-rebuild switch --flake .#$(domain) $(substituter); \
		fi
osb:
		@if [ "$(isNixOS)" = "TRUE" ]; then \
			sudo nixos-rebuild boot --flake .#$(domain) $(substituter); \
		fi

install-nix:
	@if [ "$(isNixOS)" = "TRUE" ]; then \ 
		@echo "Why did you trying to use script ?\n It's unnecessary !" \ 
		@exit 1 \ 
	else \ 
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install \ 
		# ref: https://github.com/DeterminateSystems/nix-installer
	fi

uninstall-nix:
	@if [ "$(isNixOS)" = "TRUE" ]; then \ 
		@echo "Why did you trying to use script ?\n It's unnecessary !" \ 
		@exit 1 \ 
	else \ 
		ifeq ($(wildcard $(/nix/nix-installer)),)
			@echo "Your nix wasn't install my DeterminateSystems/nix-installer" \ 
			@echo "Maybe you could check https://github.com/jackyliu16/devenv-flask/commit/7fbf044a58bb55a299771d0c947268bed7c84303"
			@echo "to get some sort of inspiration. (If you are not using macOS)"
	 	else \ 
			/nix/nix-installer uninstall \
	fi


