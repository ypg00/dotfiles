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

time:
    @echo "Singapore      (SGT):   $(TZ="Asia/Singapore" date +"%d/%m/%Y %H:%M:%S")"
    @echo "Raleigh         (ET):   $(TZ="America/New_York" date +"%d/%m/%Y %H:%M:%S")"
    @echo "Heilbronn (CET/CEST):   $(TZ="Europe/Berlin" date +"%d/%m/%Y %H:%M:%S")"
