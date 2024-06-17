# Docs: https://github.com/casey/just

DOTFILES := "${HOME}/.dotfiles"
SCRIPTS := "{{DOTFILES}}/.install"
SYMLINK := "{{SCRIPTS}}/symlink.sh"
ASDF := "{{SCRIPTS}}/asdf.sh"

default:
	@just --list

symlink:
	chmod u+x {{SYMLINK}}
	{{SYMLINK}}

asdf:
	chmod u+x {{ASDF}}
	{{ASDF}}
