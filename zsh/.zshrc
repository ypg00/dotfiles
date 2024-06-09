#!/usr/bin/env zsh

# ----- Homebrew -----
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- ENV -----
export LANG=en_US.UTF-8
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export ABBR_USER_ABBREVIATIONS_FILE=$HOME/.dotfiles/zsh-abbr/abbr

# ------ EDITORS -----
EDITOR=nvim

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi

# ----- SCRIPTS -----
# alias awsenv="python $HOME/workspace/_scripts/switch_aws_env.py"
alias gcb="$HOME/workspace/_scripts/git_clone_bare.sh" # Clones a repo with a bare git dir and single worktree
# alias k8s="$HOME/workspace/_scripts/kube_switch.sh"

# ----- ALIASES ------
alias biu="brew_install_update"
alias dare="cd $HOME/workspace/dare/"
alias dotfiles="cd $HOME/.dotfiles/"
alias dw="cd $HOME/workspace/"
alias e=$EDITOR
alias envim="$EDITOR $HOME/.dotfiles/nvim/init.lua"
alias erc="$EDITOR $HOME/.zshrc"
alias et="rm -rf $HOME/.Trash/*"
alias lg="lazygit"
alias ls='eza -lah --group-directories-first'
alias ls\ -T='eza -lahT --group-directories-first'
alias p="ipython"
# alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql # rather than adding to the path
alias src="source $HOME/.zshrc"

# ----- FUNCTIONS ------
# Homebrew
bu() {
  brew update &&
  brew upgrade &&
  brew cleanup
}

brew_install_update() {
  # Updates Brewfile, adds and commits changes, and pushes to remote each time
  # a new package is installed with brew
  brew install "$1"
  # Use a subshell to avoid changing the cwd
  (
    cd $HOME/.dotfiles/homebrew/
    brew bundle dump --describe --force --file=Brewfile
    if [[ `git status --porcelain` ]]; then
      git add Brewfile
      git commit -m "Update Brewfile after installing $1"
      git push origin main
    fi
  )
}

# Daily Logs
daily() {
  local daily_dir="$HOME/workspace/_dailies/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$daily_dir"
  $EDITOR +e "$today"
}

# General Notes
note() {
  local note_dir="$HOME/workspace/_notes/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$note_dir"
  $EDITOR +e "$today"
}

# Print path with each element on a new line
path() {
  echo -e "${PATH//:/\\n}"
}

# Questions
q() {
  local note_dir="$HOME/workspace/_notes/"
  local question_file="questions.md"
  cd "$note_dir"
  $EDITOR +e "$question_file"
}

# ----- APPLICATION SPECIFIC SETTINGS -----

# ----- asdf -----
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# ----- fzf -----
eval "$(fzf --zsh)"
set rtp+=/opt/homebrew/opt/fzf # for Vim

# ----- abbr -----
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh # Toward end
