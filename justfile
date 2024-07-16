# Docs: https://github.com/casey/just

DOTFILES := "$HOME/dotfiles"
SCRIPTS := DOTFILES / ".install"

ASDF := SCRIPTS / "asdf.sh"
BREW := SCRIPTS / "homebrew.sh"
SYMLINK := SCRIPTS / "symlink.sh"

default:
	@just --list

asdf:
	{{ASDF}}

brew: 
	{{BREW}}

configmap:
	kubectl get configmap -n kube-system -o yaml > $HOME/workspace/dare/kubeconfigmap.yaml
	$EDITOR $HOME/workspace/dare/kubeconfigmap.yaml

symlink:
	{{SYMLINK}}

sync:
	{{BREW}}
	{{SYMLINK}}
	{{ASDF}}

time:
	@$HOME/dotfiles/.scripts/time.sh

venv:
	python -m venv venv && \
	source venv/bin/activate && \
	pip install -r requirements.txt

