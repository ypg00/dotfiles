# ------ POWERLEVEL THEME CACHING -----
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ----- ENV -----
# export PATH="$HOME/.local/bin:$PATH" # Path to lvim
# export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1
export ABBR_USER_ABBREVIATIONS_FILE=$HOME/workspace/dotfiles/zsh-abbr/abbr

# ---- OMZ -----
# zstyle ':omz:update' mode reminder  # omz auto-update behavior
# DISABLE_MAGIC_FUNCTIONS="true" # Uncomment the following line if pasting URLs and other text is messed up.
# HIST_STAMPS="yyyy-mm-dd" # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# PROMPT='%{%F %T%} %m %n%# '
# source $ZSH/oh-my-zsh.sh
# export MANPATH="/usr/local/man:$MANPATH"

# ----- PLUGINS -----
plugins=( # Standard plugins $ZSH/plugins/ - Custom plugins $ZSH_CUSTOM/plugins/
	# macos # ofd: open in finder
	# sudo # esc esc: prefix sudo before last command
	# web-search
	# zsh-autosuggestions
)

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
alias dotfiles="cd $HOME/workspace/dotfiles/"
alias dw="cd $HOME/workspace/"
alias e=$EDITOR
alias erc="$EDITOR $HOME/workspace/dotfiles/zsh/.zshrc"
alias et="rm -rf $HOME/.Trash/*"
alias lg="lazygit"
alias ls='eza -lah --group-directories-first'
alias ls\ -T='eza -lahT --group-directories-first'
alias p="ipython"
alias path='echo -e ${PATH//:/\\n}' # FIX: not working properly
# alias slp="open -a ScreenSaverEngine" # abbr
# alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql # rather than adding to the path
alias src="source $HOME/.zshrc"
# alias ve="cd $HOME/.local/share/virtualenvs/" # abbr, if pipenv is brew installed

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

# ----- zsh-autosuggestions -----
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ----- zsh-completions -----
# fpath=(/usr/local/share/zsh-completions $fpath)

# ---- SSH ----
# eval $(ssh-agent)

# ----- abbr -----
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh # Toward end

# ----- Starship -----
# eval "$(starship init zsh)" # Toward end

# ----- OMZ theme -------
# source ~/powerlevel10k/powerlevel10k.zsh-theme # Toward end
