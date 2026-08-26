#!/usr/bin/env zsh

setopt ERR_EXIT NO_UNSET PIPE_FAIL

repo_dir=${0:A:h}
config_dir="$repo_dir/DynamicProfiles"
local_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

if [[ ! -d "$local_dir" ]]; then
  print -u2 "iTerm2 DynamicProfiles directory not found: $local_dir"
  print -u2 "Export a profile as JSON from iTerm2 Settings > Profiles > Other Actions first."
  exit 1
fi

mkdir -p "$config_dir"

copied=0
for source_file in "$local_dir"/*; do
  [[ -f "$source_file" ]] || continue
  cp -p "$source_file" "$config_dir/${source_file:t}"
  print "Backed up $source_file -> $config_dir/${source_file:t}"
  copied=$((copied + 1))
done

if (( copied == 0 )); then
  print -u2 "No iTerm2 Dynamic Profiles found in $local_dir"
  exit 1
fi

print "iTerm2 Dynamic Profiles backup complete."
