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