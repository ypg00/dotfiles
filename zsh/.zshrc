#!/usr/bin/env zsh

# ----- Homebrew -----
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- zsh -----
# Initialize zsh completion system
autoload -Uz compinit
compinit

# ----- Cargo -----
# . "$HOME/.cargo/env"

# ----- ENV -----
export ABBR_USER_ABBREVIATIONS_FILE=$HOME/dotfiles/zsh-abbr/abbr
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export LANG=en_US.UTF-8
# export POETRY_CONFIG_DIR=$HOME/.config/pypoetry
# export POETRY_DATA_DIR=~/.local/share/pypoetry

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

# Node information
k8s_node_info() {
  local node_data=$(kubectl get nodes --no-headers)
  local top_data=$(kubectl top nodes)
  local node_details=$(kubectl get nodes -o custom-columns="NAME:.metadata.name,INSTANCE-TYPE:.metadata.labels['node\.kubernetes\.io/instance-type'],ZONE:.metadata.labels['topology\.kubernetes\.io/zone']")
  printf "%-50s %-15s %-15s %-12s %-7s %-15s %-10s %-10s\n" "NAME" "INSTANCE-TYPE" "ZONE" "CPU(cores)" "CPU(%)" "MEMORY(bytes)" "MEMORY(%)" "AGE"
  echo "$node_details" | tail -n +2 | while read -r node_line; do
    local node_name=$(echo "$node_line" | awk '{print $1}')
    local instance_type=$(echo "$node_line" | awk '{print $2}')
    local zone=$(echo "$node_line" | awk '{print $3}')
    local age=$(echo "$node_data" | grep "$node_name" | awk '{print $4}')
    local usage=$(echo "$top_data" | grep "$node_name")
    
    if [[ -n "$usage" ]]; then
      local cpu_cores=$(echo "$usage" | awk '{print $2}')
      local cpu_percent=$(echo "$usage" | awk '{print $3}')
      local mem_bytes=$(echo "$usage" | awk '{print $4}')
      local mem_percent=$(echo "$usage" | awk '{print $5}')
      printf "%-50s %-15s %-15s %-12s %-7s %-15s %-10s %-10s\n" "$node_name" "$instance_type" "$zone" "$cpu_cores" "$cpu_percent" "$mem_bytes" "$mem_percent" "$age"
    else
      printf "%-50s %-15s %-15s %-12s %-7s %-15s %-10s %-10s\n" "$node_name" "$instance_type" "$zone" "N/A" "N/A" "N/A" "N/A" "$age"
    fi
  done
}
alias nodes='k8s_node_info'

# Kubernetes log helper function
klog() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: klog <namespace> <deployment> [search term]"
    echo "Example: klog argo argo-workflows-controller error"
    return 1
  fi

  local namespace="$1"
  local deployment="$2"
  local search_term="$3"

  if ! kubectl get namespace "$namespace" &>/dev/null; then
    echo "Error: Namespace '$namespace' does not exist"
    return 1
  fi

  local pod_name
  pod_name=$(kubectl get pods -n "$namespace" -l "app.kubernetes.io/name=$deployment" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
  if [[ -z "$pod_name" ]]; then
    local selector
    selector=$(kubectl get deployment -n "$namespace" "$deployment" -o jsonpath='{.spec.selector.matchLabels}' 2>/dev/null)

    if [[ -n "$selector" ]]; then
      selector=$(echo "$selector" | tr -d '{}' | tr ',' ' ' | sed 's/:/=/g' | sed 's/"//g')
      pod_name=$(kubectl get pods -n "$namespace" -l "$selector" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    fi
  fi

  if [[ -z "$pod_name" ]]; then
    echo "Error: No pods found for deployment '$deployment' in namespace '$namespace'"
    echo "Available deployments in namespace '$namespace':"
    kubectl get deployments -n "$namespace"
    echo -e "\nPod labels in this namespace:"
    kubectl get pods -n "$namespace" --show-labels
    return 1
  fi

  local cmd="kubectl logs -n $namespace $pod_name"
  if [[ -n "$search_term" ]]; then
    cmd="$cmd | grep -i '$search_term'"
  fi
  echo "Executing: $cmd"
  echo "Pod: $pod_name"
  echo "---"
  eval "$cmd"
}
# Add zsh completion
_klog() {
  local state

  _arguments \
    '1: :->namespace' \
    '2: :->deployment' \
    '3: :->search_term'

  case $state in
    namespace)
      local namespaces
      namespaces=($(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'))
      _values 'namespaces' $namespaces
      ;;
    deployment)
      local deployments
      deployments=($(kubectl get deployments -n "$words[2]" -o jsonpath='{.items[*].metadata.name}'))
      _values 'deployments' $deployments
      ;;
    search_term)
      ;;
  esac
}
# Register the completion function
compdef _klog klog

# ----- APPLICATION SPECIFIC SETTINGS -----

# ----- asdf -----
# . /opt/homebrew/opt/asdf/libexec/asdf.sh
# . /opt/homebrew/opt/asdf/bin/asdf
# export PATH="/opt/homebrew/Cellar/asdf/0.16.4/bin:$PATH"
# Add both asdf binary and shims to PATH
export PATH="/opt/homebrew/Cellar/asdf/0.16.5/bin:$HOME/.asdf/shims:$PATH"

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
# source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh # Toward end
source /opt/homebrew/share/zsh-abbr@5/zsh-abbr.zsh
