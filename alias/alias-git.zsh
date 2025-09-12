#git
alias g='git'
alias gg='lazygit'

alias gm='git checkout main && fh sync && fh prune'
alias ga='git add'
alias gu='git unadd'    # git config --global alias.unadd reset HEAD
alias grb='git rebase'
alias gcp='git cherry-pick'
alias gca='git commit -v --amend'
alias gcm='git commit -m'
alias gempty="git commit --allow-empty -m 'empty'"

alias gb='git branch'
alias gr='git remote -v'
alias gf='git fetch'
alias gfa='git fetch --all'

_git_push_auto_branch() {
  local remote
  local rest
  # remote is a git push option
  if [[ $1 = -* ]]; then
    remote="origin"
    rest=( "$@" )
  # no argument supplied
  elif [[ -z $1 ]]; then
    remote="origin"
    rest=( "$@" )
  # remote name provided
  else
    remote=$1;shift
    rest=( "$@" )
  fi
  git push -u $remote $(git symbolic-ref --short -q HEAD) "${rest[@]}"
}

alias gco='git checkout'
# TODO if on master branch check if upstream exists. Sync. create branch user.id/branch-name
alias gnew='git checkout -b'
alias gpush='fh push'
alias gprune="git remote prune origin | grep -o '\[pruned\] origin\/.*$' | sed -e 's/\[pruned\] origin \///' | xargs git branch -D"

alias gpop='git reset --soft head^ && git unadd :/'
alias gsave='git add :/ && git commit -m "save point"'

alias gs='git status -sb'
wcd() {
    cd "$(gh fh worktree path)"
}

fl() {
  local upstream=$(git remote | grep -q upstream && echo upstream || echo origin)
  local main=$(git branch -l main master --format '%(refname:short)')

  git log --color --graph --pretty=format:"%Cred%h%Creset %C(blue)<%an>%Creset %s -%C(bold yellow)%d%Creset %Cgreen(%cr)" --abbrev-commit $upstream/$main.. $1
}

fll() {
  local upstream=$(git remote | grep -q upstream && echo upstream || echo origin)
  local main=$(git branch -l main master --format '%(refname:short)')

  git log --stat --abbrev-commit $upstream/$main.. $1
}

flll() {
  local upstream=$(git remote | grep -q upstream && echo upstream || echo origin)
  local main=$(git branch -l main master --format '%(refname:short)')

  git log --stat -p --abbrev-commit $upstream/$main.. $1
}


alias fh="gh fh"
alias fco="gh fh checkout"
alias fm="gh fh view"
alias fs="gh fh sync"
alias pco="gh fh pr checkout"
alias pv="gh fh pr view"

alias gl='git log --color --graph --pretty=format:"%Cred%h%Creset %C(blue)<%an>%Creset %s -%C(bold yellow)%d%Creset %Cgreen(%cr)" --abbrev-commit'
alias gll='git log --stat'
alias glll='git log --stat -p'
alias gld='__git_commit_diff'
alias gd='git diff HEAD'

alias grb='git rebase'
alias grm='git rm $(git ls-files --deleted)'

_git-stash-fzf() {
  git --no-pager stash list | sed 's/: / /' | fzf +m --preview-window='bottom:75%' --preview='git stash show {1} && echo "---" && git --no-pager stash show --color=always -p {1}' | cut -f1 -d ' '
}

alias gspop="_git-stash-fzf | xargs git stash pop"

# pick bits from a file to apply to current branch
# git checkout -p <branch> -- <some file>

# find PR from commit
# gh pr list --search "<SHA>" --state merged
