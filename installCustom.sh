#!/usr/bin/env zsh

systemName=$(uname)

case "Darwin" in
$systemName)
  echo "Adding nobody to staff group"
  sudo dseditgroup -o edit -a nobody -t user staf
  ;;
esac

echo "Creating customZsh symlink"
ln -s ${PWD}/.customZsh ~/.customZsh

echo "DONE

You can now run

updateProjectDB

to set up the project list"
