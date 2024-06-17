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

symlink:
	{{SYMLINK}}

sync:
	{{SYMLINK}}
	{{BREW}}
	{{ASDF}}
