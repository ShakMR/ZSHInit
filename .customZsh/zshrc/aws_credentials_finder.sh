#!/usr/bin/env zsh

_get_credentials() {
  local profile_name=$1
  local credentials_file="$HOME/.aws/credentials"

  if [[ ! -f $credentials_file ]]; then
    echo "Error: AWS credentials file not found at $credentials_file"
    exit 1
  fi

  # Extract the profile section and transform it into environment variable setters
  awk -v profile="[$profile_name]" '
    $0 == profile { in_profile = 1; next }
    /^\[.*\]/ { in_profile = 0 }
    in_profile && $1 ~ /^[a-zA-Z0-9_]+/ {
      key = $1
      value = $2
      for (i = 3; i <= NF; i++) value = value $i
      gsub(/^[ \t]+|[ \t]+$/, "", key)
      gsub(/^[ \t]+|[ \t]+$/, "", value)
      print toupper(key) value
    }
  ' "$credentials_file"
}

get_credentials() {
  local credentials_file="$HOME/.aws/credentials"

  if [[ ! -f $credentials_file ]]; then
    echo "Error: AWS credentials file not found at $credentials_file"
    exit 1
  fi

  if [[ $# -eq 1 && $1 == "-ls" ]]; then
    # List all profiles in the credentials file
    awk '/^\[.*\]/ { gsub(/[\[\]]/, "", $0); print $0 }' "$credentials_file"
    return
  fi

  if [[ $# -ne 2 || $1 != "-p" ]]; then
    echo "Usage: get_credentials -p profile_name"
    echo "       get_credentials -ls"
    exit 1
  fi

  # Call the function with the provided profile name
  _get_credentials "$2"
}

_get_credentials_autocomplete() {
  local credentials_file="$HOME/.aws/credentials"

  if [[ -f $credentials_file ]]; then
    # Extract profile names from the credentials file
    local profiles=$(awk '/^\[.*\]/ { gsub(/[\[\]]/, "", $0); print $0 }' "$credentials_file")
    reply=($(echo $profiles))
  fi
}

compctl -K _get_credentials_autocomplete get_credentials
