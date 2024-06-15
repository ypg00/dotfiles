# DOCS: https://github.com/casey/just

DOTFILES := "${HOME}/.dotfiles"
SCRIPTS := "{{DOTFILES}}/.install"
SYMLINK := "{{SCRIPTS}}/symlink.sh"

default:
	@just --list

symlink:
	chmod +x {{SYMLINK}}
	{{SYMLINK}}