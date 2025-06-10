alias generateCert=openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

alias findPortMac="netstat -vanp tcp | grep"

alias findMyIP="curl ipinfo.io"

 # Set iTerm2 tab titles to the last directory in PWD
tabTitle() { echo -ne "\033]0;"$*"\007"; }
# Set iTerm2 win titles to the full directory of PWD
winTitle() { echo -ne "\033]2;"$*"\007"; }

# Alias 'cd' to list directory and set title
unalias cd
cd() {
  builtin cd "$@"; ls -lFah; tabTitle ${PWD##*/}; winTitle ${PWD/#"$HOME" /~};
}

convertVideoToMp4() {
  if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: convertMovToMp4 <file>"
    return 1
  fi

  local filename="${1%.*}"
  ffmpeg -i "$1" -vcodec h264 -acodec aac "${filename}.mp4";
}

compressMp4() {
  if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: compressMp4 <file>"
    return 1
  fi

  local filename="${1%.*}"
  ffmpeg -i "$1" -vcodec libx264 -vsync 2 -crf 24 "${filename}-compressed.mp4";
}

function set_tab_title {
    echo -ne "\033]0;"$*"\007"
}

set_git_tab_title() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -ne "\033]0;${PWD##*/}\007"
    return
  fi
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
  if [ -n "$branch" ] && [ -n "$repo" ]; then
    echo -ne "\033]0;${repo}:${branch}\007"
  else
    echo -ne "\033]0;${PWD##*/}\007"
  fi
}

replay() {
    if [ $# -ne 2 ]; then
        echo "Usage: runEveryXSeconds \"command\" seconds"
        return 1
    fi

    local command="$1"
    local seconds="$2"

    # Validate that seconds is a positive number
    if ! [[ "$seconds" =~ ^[0-9]+$ ]]; then
        echo "Error: seconds must be a positive number"
        return 1
    fi

    # Make sure input is immediately available without Enter key
    stty -icanon

    while true; do
        eval "$command"
        
        # Wait for either the specified time or 'r' key press
        local start_time=$(date +%s)
        while true; do
            # Check for 'R' key press (non-blocking)
            if read -t 0.1 -n 1 key && [ "$key" = "r" ]; then
                break
            fi
            
            # Check if we've reached the specified time
            if [ $(($(date +%s) - start_time)) -ge $seconds ]; then
                break
            fi
        done
    done
}