# Docs: https://github.com/casey/just

DOTFILES := "$HOME/.dotfiles"
SCRIPTS := DOTFILES / ".install"

ASDF := SCRIPTS / "asdf.sh"
SYMLINK := SCRIPTS / "symlink.sh"

default:
	@just --list

asdf:
	{{ASDF}}

symlink:
	{{SYMLINK}}

sync:
	{{SYMLINK}}
	{{ASDF}}
