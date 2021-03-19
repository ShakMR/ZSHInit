
git config --global alias.comdiff 'log --graph --abbrev-commit --date=relative master..HEAD'
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.p 'push origin HEAD'
git config --global alias.pfoh 'git push --force-with-lease origin HEAD'

openPR () {
    url=$(git remote show origin | grep "Push *URL" | cut -d "@" -f 2 | sed 's/:/\//' | sed -e 's/\.git//' | xargs -I % echo https://%/compare/$(git branch | grep \* | cut -d ' ' -f2)?expand=1)
    open ${url}
}

openGitHub () {
    url=$(git remote show origin | grep "Push *URL" | cut -d "@" -f 2 | sed 's/:/\//' | sed -e 's/\.git//' | xargs -I % echo https://%)
    open ${url}
}
