#!/usr/bin/env zsh

setopt ERR_EXIT NO_UNSET PIPE_FAIL

repo_dir=${0:A:h}
config_dir="$repo_dir/prezto-config"
backup_root="$HOME/.zshinit-prezto-backups"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)-$$"

for config_file in .zpreztorc .p10k.zsh; do
  if [[ ! -f "$config_dir/$config_file" ]]; then
    print -u2 "Missing repository config: $config_dir/$config_file"
    exit 1
  fi
done

mkdir -p "$backup_dir"

for config_file in .zpreztorc .p10k.zsh; do
  local_file="$HOME/$config_file"

  if [[ -e "$local_file" || -L "$local_file" ]]; then
    cp -pL "$local_file" "$backup_dir/$config_file"
    print "Backed up current $local_file -> $backup_dir/$config_file"
  fi

  cp -p "$config_dir/$config_file" "$local_file"
  print "Restored $config_dir/$config_file -> $local_file"
done

print "Local backup saved in $backup_dir"
print "Prezto configuration restore complete. Restart Zsh to apply it."
