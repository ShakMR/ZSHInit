autoload -Uz _saml2aws

_saml2aws_with_profiles() {
  if [[ $words[2] == login && $words[CURRENT-1] == -a ]]; then
    local -a profiles=("${(@f)$(sed -n 's/^\[\(.*\)\]$/\1/p' ~/.saml2aws)}")
    _describe 'SAML profile' profiles
  else
    _saml2aws "$@"
  fi
}

compdef _saml2aws_with_profiles saml2aws
