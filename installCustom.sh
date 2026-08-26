#!/usr/bin/env zsh

systemName=$(uname)

case "Darwin" in
$systemName)
  echo "Adding nobody to staff group"
  sudo dseditgroup -o edit -a nobody -t user staf
  ;;
esac

echo "Creating customZsh symlink"
ln -sfn ${PWD}/.customZsh ~/.customZsh

echo "Installing Vim configuration"
if [[ -e "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
  echo "A regular ~/.vimrc already exists; leaving it unchanged"
else
  ln -sfn "${PWD}/.vimrc" "$HOME/.vimrc"
fi

echo source ~/.customZsh/zshBasic.sh >> $HOME/.zshrc

echo "Updating projects DB"
updateProjectsDB

echo "DONE"
