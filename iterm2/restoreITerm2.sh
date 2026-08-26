#!/usr/bin/env zsh

setopt ERR_EXIT NO_UNSET PIPE_FAIL

repo_dir=${0:A:h}
config_dir="$repo_dir/DynamicProfiles"
local_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
backup_root="$HOME/.zshinit-iterm2-backups"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)-$$"

if [[ ! -d "$config_dir" ]]; then
  print -u2 "Repository iTerm2 configuration not found: $config_dir"
  exit 1
fi

config_files=("$config_dir"/*(.N))
if (( ${#config_files} == 0 )); then
  print -u2 "No iTerm2 Dynamic Profiles found in $config_dir"
  print -u2 "Run ./backupITerm2.sh after exporting a profile from iTerm2 first."
  exit 1
fi

mkdir -p "$local_dir"
mkdir -p "$backup_dir"

if [[ -n "$(find "$local_dir" -maxdepth 1 -type f -print -quit 2>/dev/null)" ]]; then
  cp -pR "$local_dir"/. "$backup_dir"/
  print "Backed up current iTerm2 Dynamic Profiles -> $backup_dir"
fi

for source_file in "$config_files[@]"; do
  cp -p "$source_file" "$local_dir/${source_file:t}"
  print "Restored $source_file -> $local_dir/${source_file:t}"
done

print "Local backup saved in $backup_dir"
print "iTerm2 Dynamic Profiles restore complete. Restart iTerm2 if changes are not visible."
