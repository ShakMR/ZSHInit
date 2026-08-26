#!/usr/bin/env zsh

setopt ERR_EXIT NO_UNSET PIPE_FAIL

repo_dir=${0:A:h}
config_dir="$repo_dir/prezto-config"

mkdir -p "$config_dir"

for config_file in .zpreztorc .p10k.zsh; do
  local_file="$HOME/$config_file"

  if [[ ! -f "$local_file" ]]; then
    print -u2 "Skipping missing $local_file"
    continue
  fi

  cp -p "$local_file" "$config_dir/$config_file"
  print "Backed up $local_file -> $config_dir/$config_file"
done

print "Prezto configuration backup complete."
