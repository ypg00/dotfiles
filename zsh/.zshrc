#!/usr/bin/env zsh

# ----- Homebrew -----
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- ENV -----
export ABBR_USER_ABBREVIATIONS_FILE=$HOME/dotfiles/zsh-abbr/abbr
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export LANG=en_US.UTF-8
export POETRY_CONFIG_DIR=$HOME/.config/pypoetry
export POETRY_DATA_DIR=~/.local/share/pypoetry

# ----- PROMPT ------
RESET="%{$(tput sgr0)%}"
RED="%{$(tput setaf 1)%}"
GREEN="%{$(tput setaf 2)%}"
YELLOW="%{$(tput setaf 3)%}"
BLUE="%{$(tput setaf 4)%}"
MAGENTA="%{$(tput setaf 5)%}"
CYAN="%{$(tput setaf 6)%}"
WHITE="%{$(tput setaf 7)%}"

function git_prompt_info() {
  local branch
  branch=$(git symbolic-ref HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "${GREEN}($(echo $branch | sed 's/refs\/heads\///'))${RESET}"
  fi
}

function zsh_prompt_command() {
  local date_time
  date_time=$(date +"%d/%m/%Y | %H:%M:%S")
  RPROMPT="%{$CYAN%}${date_time}%{$RESET%}"
  PS1="%{$CYAN%}%~ $(git_prompt_info)%{$RESET%}
%{$RED%}λ%{$RESET%} "
}

# Ensure the prompt is updated after each command
precmd_functions+=(zsh_prompt_command)

# Initial call to set the prompt
zsh_prompt_command

# ------ EDITORS -----
EDITOR=nvim

if [[ -n ${SSH_CONNECTION:-} ]]; then
  export EDITOR='vim'
else
  export EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi

alias e="$EDITOR"

# ----- SCRIPTS -----
alias awsenv="python $HOME/dotfiles/.scripts/switch_aws_env.py"
alias biu="brew_install_update"
alias gcb="$HOME/dotfiles/.scripts/git_clone_bare.sh" # Clones a repo with a bare git dir and single worktree
alias k8s="$HOME/dotfiles/.scripts/kube_switch.sh"

# ----- FUNCTIONS ------

# Homebrew
bu() {
  brew update &&
  brew upgrade &&
  brew cleanup
}

brew_install_update() {
  local package="$1"
  brew install "$package"
  if [[ $? -eq 0 ]]; then
    pushd $HOME/dotfiles/homebrew/ > /dev/null
    echo "$package" >> packages
    popd > /dev/null
  else
    echo "Failed to install $package"
  fi
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

# ----- zsh-completions -----
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# ----- abbr -----
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh # Toward end
