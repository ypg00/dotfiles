# Docs: https://github.com/casey/just

DOTFILES := "$HOME/dotfiles"
SCRIPTS := DOTFILES / ".install"

ASDF := SCRIPTS / "asdf.sh"
BREW := SCRIPTS / "homebrew.sh"
SYMLINK := SCRIPTS / "symlink.sh"

default:
	@just --list

asdf:
	cd $HOME/dotfiles/
	git pull
	{{ASDF}}

brew: 
	cd $HOME/dotfiles/
	git pull
	{{BREW}}

symlink:
	cd $HOME/dotfiles/
	git pull
	{{SYMLINK}}

sync:
	cd $HOME/dotfiles/
	git pull
	{{SYMLINK}}
	{{BREW}}
	{{ASDF}}
