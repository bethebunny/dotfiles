# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Don't show duplicates in history search
setopt HIST_FIND_NO_DUPS
# Share history between terminals
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# Additional history details
setopt EXTENDED_HISTORY

setopt appendhistory extendedglob nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
prompt adam2
setopt prompt_sp

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# this includes setting up some path stuff
autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
[ -f ~/.bash_profile ] && . ~/.bash_profile
#[ -f ~/.bashrc ] && . ~/.bashrc
[ -f ~/.aliases ] && . ~/.aliases

# add vesion control to prompt?
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='%B%F{yellow}$VIRTUAL_ENV%F{red}$vcs_info_msg_0_%f%b'
# Show the branch with a space in front of it to separate it from venv
zstyle ':vcs_info:git:*' formats ' %b'
zstyle ':vcs_info:*' enable git

# Report time taken if more than this many seconds
REPORTTIME=10

# ls after cd
function chpwd {
  [[ $(ls | wc -l) -gt 10 ]] && ls || ls -l
}

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# CTRL-G - Select recent git branch from fzf
fzf-recent-branch-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  echo  # retain current prompt line
  git for-each-ref --count=10 --sort=-committerdate refs/heads/ --format='%(refname:short)' \
    | fzf --height 50 --preview 'git diff --stat --patch --color $(git merge-base master {-1}) {-1}' \
    | xargs git checkout
  local ret=$?
  zle send-break
  return $ret
}

zle     -N   fzf-recent-branch-widget
bindkey '^G' fzf-recent-branch-widget
