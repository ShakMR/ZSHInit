#default_user=borjaarias
#export VISUAL=vim
#export EDITOR="${VISUAL}"
#unsetopt share_history
#
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt no_share_history
unsetopt share_history

zshrcFolder=${CUSTOM_ZSH:-$HOME}/.customZsh/zshrc

echo ${zshrcFolder}
for file in $(ls ${zshrcFolder}); do
    echo $file
    source ${zshrcFolder}/${file}
done

## WORK RELATED FILES
echo ${zshrcFolder}/team
for file in $(ls ${zshrcFolder}); do
    echo $file
    source ${zshrcFolder}/${file}
done

autoload -Uz compinit
compinit

export FPATH=~/.customZsh/completion/:~/.customZsh/zshrc/:$FPATH
export PROJECTS_HOME=~/Projects
