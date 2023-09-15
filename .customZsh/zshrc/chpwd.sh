# Activate virtual environment if it is present

# Define chpwd function
function chpwd() {
  # Check if the current directory is a virtual environment
  if [[ -d ".venv" ]]; then
    # Check if the virtual environment is already activated
    if [[ -z "$VIRTUAL_ENV" ]]; then
      # Activate the virtual environment
      echo -e "\n[\xe2\x86\x91][Activating] virtual environment."
      source .venv/bin/activate
      echo -e "[\xe2\x9c\x93][Activated] virtual environment: '$VIRTUAL_ENV'.\n"
    fi
  else
    # Check if a matching virtual environment exists in ~/.virtualenvs
    local venv_name=$(basename "$PWD")
    local venv_pattern="${venv_name}*"
    local venv_path=$(find "$HOME/.virtualenvs" -maxdepth 1 -type d -name "$venv_pattern" -print -quit)

    if [[ -n "$venv_path" ]]; then
      # Check if a virtual environment is already activated
      if [[ -z "$VIRTUAL_ENV" || "$VIRTUAL_ENV" != "$venv_path" ]]; then
        # Activate the virtual environment
        echo -e "\n[\xe2\x86\x91][Activating] virtual environment."
        source "$venv_path/bin/activate"
        echo -e "[\xe2\x9c\x93][Activated] virtual environment: '$VIRTUAL_ENV'.\n"
      fi
    else
      # Check if a virtual environment is currently activated
      if [[ -n "$VIRTUAL_ENV" ]]; then
        # Deactivate the virtual environment
        echo -e "\n[\xe2\x86\x93][Deactivating] virtual environment '$VIRTUAL_ENV'."
        deactivate
        echo -e "[\xe2\x9c\x97][Deactivated] virtual environment.\n"
      fi
    fi
  fi
}

# Set the chpwd function to be autoloaded
autoload -Uz chpwd
