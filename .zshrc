# ------ POWERLEVEL THEME CACHING -----
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ----- ENV -----
# export PATH="$HOME/.local/bin:$PATH" # Path to lvim
# export ZSH="$HOME/.oh-my-zsh"
# export EDITOR=nvim
# export VISUAL=nvim
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1

# ---- OMZ -----
zstyle ':omz:update' mode reminder  # omz auto-update behavior
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

# ------ SET EDITORS -----
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# ----- SCRIPTS -----
# alias awsenv="python $HOME/workspace/_scripts/switch_aws_env.py"
alias gcb="$HOME/workspace/_scripts/git_clone_bare.sh" # Clones a repo with a bare git dir and single worktree
# alias k8s="$HOME/workspace/_scripts/kube_switch.sh"

# ----- ALIASES ------
alias dare="cd $HOME/workspace/dare/"
alias dw="cd $HOME/workspace/"
alias e="nvim"
alias erc="nvim $HOME/.zshrc"
alias et="rm -rf $HOME/.Trash/*"
alias ls='eza -lah --group-directories-first'
alias ls\ -T='eza -lahT --group-directories-first'
alias p="ipython"
# alias ps="procs"
alias sl="open -a ScreenSaverEngine"
# alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql # rather than adding to the path
alias src="source $HOME/.zshrc"

# ----- FUNCTIONS ------
# Homebrew
bu() {
  brew update &&
  brew upgrade &&
  brew cleanup
}

# Daily Logs
daily() {
  local daily_dir="$HOME/workspace/_dailies/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$daily_dir"
  nvim +e "$today"
}

# General Notes
note() {
  local note_dir="$HOME/workspace/_notes/"
  local date_format=$(date +"%Y_%m_%d")
  local today="${date_format}.md"
  cd "$note_dir"
  nvim +e "$today"
}

# Questions
q() {
  local note_dir="$HOME/workspace/_notes/"
  local question_file="questions.md"
  cd "$note_dir"
  nvim +e "$question_file"
}

# ----- abbr -----
# source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

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

# ----- Starship -----
# eval "$(starship init zsh)" # Toward end

# ----- OMZ theme -------
# source ~/powerlevel10k/powerlevel10k.zsh-theme # Toward end
