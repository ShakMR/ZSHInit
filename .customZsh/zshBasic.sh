#default_user=borjaarias
export VISUAL=vim
export EDITOR="${VISUAL}"
#unsetopt share_history
#
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


function prompt_arch() {
  if [ $(arch) = 'i386' ]; then
    p10k segment -b blue -f white -t "$(arch)"
  else
    p10k segment -b red -f black -t "$(arch)"
  fi
}

export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon arch dir vcs newline)

alias mzsh="arch -arm64 zsh"
alias izsh="arch -x86_64 zsh"

setopt no_share_history
unsetopt share_history

zshrcFolder=${CUSTOM_ZSH:-$HOME}/.customZsh/zshrc

for file in $(ls ${zshrcFolder}); do
  source ${zshrcFolder}/${file}
done

## WORK RELATED FILES
for file in $(ls ${zshrcFolder}/team); do
  source ${zshrcFolder}/team/${file}
done

autoload -Uz compinit
compinit

export FPATH=~/.customZsh/completion/:~/.customZsh/zshrc/:$FPATH
export PROJECTS_HOME=~/Projects
