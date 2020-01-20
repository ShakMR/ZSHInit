export PATH="${HOME}/.pyenv/bin:${PATH}"

export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"

eval "$(/usr/local/bin/pyenv init -)"
eval "$(/usr/local/bin/pyenv virtualenv-init -)"
