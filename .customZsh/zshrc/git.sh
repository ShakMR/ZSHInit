
git config --global alias.comdiff 'log --graph --abbrev-commit --date=relative master..HEAD'
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.p 'push origin HEAD'
git config --global alias.pfoh 'push --force-with-lease origin HEAD'

branchName () {
  git branch | grep "\*" | cut -d' ' -f 2
}

masterC () {
  export PREV_BRANCH="$(branchName)"
  echo "saving changes"
  git stash
  git checkout master && git fetch && git pull origin master
}

backC () {
  git checkout "$PREV_BRANCH"
}

backS() {
  git checkout "$PREV_BRANCH"
  git stash pop
}

_getGitHubUrl() {
  echo "https://$(git remote show origin | grep "Push *URL" | cut -d "@" -f 2 | sed 's/:/\//' | sed -e 's/\.git//')"
}

checkSystemOpenComm() {
    systemName=$(uname)

    if [[ ${systemName} = 'Darwin' ]]; then
        echo 'open';
    elif [[ ${systemName} = 'Linux' ]]; then
        echo 'xdg-open'
    fi
}

openPR () {
    baseUrl=$(_getGitHubUrl)
    branch=$(git branch | grep \* | cut -d ' ' -f2)

    $(checkSystemOpenComm) "${baseUrl}/compare/${branch}?expand=1"
}

openGitHub () {
    url=$(_getGitHubUrl)
    $(checkSystemOpenComm) "${url}"
}

myIssues () {
  gh issue list -a @me "$@"
}

lastBranches () {
  git branch --sort=-committerdate
}

ghAPILogin() {
  read -p 'Username: ' user
  read -sp 'Token: ' token
  export GITHUB_USER=${user}
  export GITHUB_TOKEN=${token}
}

alias gitgraph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias pullhead='git pull origin $(git rev-parse --abbrev-ref HEAD)'
