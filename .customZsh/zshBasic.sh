#default_user=borjaarias
#export VISUAL=vim
#export EDITOR="${VISUAL}"
#unsetopt share_history
#
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zshrcFolder=${CUSTOM_ZSH:-$HOME}/.customZsh/zshrc

echo ${zshrcFolder}
for file in $(ls ${zshrcFolder}); do
    echo $file
    source ${zshrcFolder}/${file}
done
