#!/bin/zsh

# Git branch management and rebasing utilities
# Usage: git-manage [option] [args...]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current branch name
_getCurrentBranch() {
    git branch --show-current
}

# Get the base branch of the current branch
_getBaseBranch() {
    local current_branch="$1"
    local best_parent=""
    local best_ts=0

    if [[ -z "$current_branch" || "$current_branch" == "main" || "$current_branch" == "master" ]]; then
        echo ""
        return
    fi

    # Find the parent branch by looking for the most recent ancestor branch
    for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
        if [[ "$branch" == "$current_branch" ]]; then
            continue
        fi

        local merge_base=$(git merge-base "$current_branch" "$branch")
        [[ -z "$merge_base" ]] && continue

        # If the merge base is the head of the other branch, it's a candidate parent
        if [[ "$merge_base" == "$(git rev-parse "$branch")" ]]; then
            local ts=$(git show -s --format=%ct "$merge_base")
            if (( ts > best_ts )); then
                best_ts=$ts
                best_parent=$branch
            fi
        fi
    done

    echo "$best_parent"
}

# Save changes and go to base branch
goToBase() {
    local current_branch="$(_getCurrentBranch)"
    local base_branch="$(_getBaseBranch "$current_branch")"
    
    if [[ -z "$base_branch" ]]; then
        echo -e "${YELLOW}No base branch found for $current_branch${NC}"
        echo -e "${BLUE}Going to main/master instead${NC}"
        base_branch="main"
        
        # Check if main exists, otherwise try master
        if ! git show-ref --verify --quiet refs/heads/main; then
            if git show-ref --verify --quiet refs/heads/master; then
                base_branch="master"
            else
                echo -e "${RED}Neither main nor master branch found${NC}"
                return 1
            fi
        fi
    fi
    
    echo -e "${BLUE}Current branch: $current_branch${NC}"
    echo -e "${BLUE}Base branch: $base_branch${NC}"
    
    # Store current branch for later return
    export PREV_BRANCH="$current_branch"
    echo -e "${GREEN}Previous branch stored: $PREV_BRANCH${NC}"
    
    # Stash changes
    echo -e "${YELLOW}Stashing changes...${NC}"
    git stash
    
    # Checkout base branch and update
    echo -e "${BLUE}Checking out $base_branch...${NC}"
    git checkout "$base_branch"
    git fetch
    git pull origin "$base_branch"
    
    echo -e "${GREEN}Successfully moved to $base_branch${NC}"
}

# Go back to previous branch
goBack() {
    if [[ -z "$PREV_BRANCH" ]]; then
        echo -e "${RED}No previous branch stored${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Returning to previous branch: $PREV_BRANCH${NC}"
    git checkout "$PREV_BRANCH"
    
    # Ask if user wants to pop stash
    if [[ -n "$(git stash list)" ]]; then
        echo -e "${YELLOW}You have stashed changes:${NC}"
        git stash show -p stash@{0}
        echo # for a newline

        read -q "REPLY?Pop stashed changes? (y/N) "
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git stash pop
        fi
    else
        echo -e "${GREEN}No stashed changes to apply.${NC}"
    fi
}

# Save changes and go to the main branch (main/master)
goToMain() {
    local current_branch="$(_getCurrentBranch)"

    # Determine main branch name
    local main_branch="main"
    if ! git show-ref --verify --quiet refs/heads/main; then
        if git show-ref --verify --quiet refs/heads/master; then
            main_branch="master"
        else
            echo -e "${RED}Neither main nor master branch found${NC}"
            return 1
        fi
    fi

    if [[ "$current_branch" == "$main_branch" ]]; then
        echo -e "${YELLOW}Already on $main_branch. Pulling latest changes.${NC}"
        git pull origin "$main_branch"
        return 0
    fi

    echo -e "${BLUE}Current branch: $current_branch${NC}"

    # Store current branch for later return
    export PREV_BRANCH="$current_branch"
    echo -e "${GREEN}Previous branch stored: $PREV_BRANCH${NC}"

    # Stash changes
    echo -e "${YELLOW}Stashing changes...${NC}"
    git stash

    # Checkout main branch and update
    echo -e "${BLUE}Checking out $main_branch...${NC}"
    git checkout "$main_branch"
    git fetch
    git pull origin "$main_branch"

    echo -e "${GREEN}Successfully moved to $main_branch${NC}"
}

# Rebase current branch from specified base
rebaseFrom() {
    local base_branch="$1"
    local current_branch="$(_getCurrentBranch)"
    
    if [[ -z "$base_branch" ]]; then
        echo -e "${RED}Please specify a base branch${NC}"
        echo -e "${BLUE}Usage: rebaseFrom <base-branch>${NC}"
        return 1
    fi
    
    if [[ "$current_branch" == "$base_branch" ]]; then
        echo -e "${RED}Cannot rebase $current_branch from itself${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Rebasing $current_branch from $base_branch...${NC}"
    
    # First, go to base branch and update it
    export PREV_BRANCH="$current_branch"
    git stash
    git checkout "$base_branch"
    git fetch
    git pull origin "$base_branch"
    
    # Then rebase current branch from updated base
    git checkout "$current_branch"
    git rebase "$base_branch"
    
    # Pop stash if there were changes
    if [[ -n "$(git stash list)" ]]; then
        git stash pop
    fi
    
    echo -e "${GREEN}Successfully rebased $current_branch from $base_branch${NC}"
}

# Cascade rebase: rebase B from main (A from main, then B from A)
cascadeRebase() {
    local current_branch="$(_getCurrentBranch)"
    local base_branch="$(_getBaseBranch "$current_branch")"
    
    if [[ -z "$base_branch" ]]; then
        echo -e "${RED}No base branch found for $current_branch${NC}"
        return 1
    fi
    
    if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
        echo -e "${RED}Cannot cascade rebase main/master branch${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Performing cascade rebase for $current_branch...${NC}"
    echo -e "${BLUE}Base branch: $base_branch${NC}"
    
    # Store current branch
    export PREV_BRANCH="$current_branch"
    
    # Step 1: Update main/master
    local main_branch="main"
    if ! git show-ref --verify --quiet refs/heads/main; then
        if git show-ref --verify --quiet refs/heads/master; then
            main_branch="master"
        else
            echo -e "${RED}Neither main nor master branch found${NC}"
            return 1
        fi
    fi
    
    echo -e "${YELLOW}Step 1: Updating $main_branch...${NC}"
    git stash
    git checkout "$main_branch"
    git fetch
    git pull origin "$main_branch"
    
    # Step 2: Rebase base branch from main
    if [[ "$base_branch" != "$main_branch" ]]; then
        echo -e "${YELLOW}Step 2: Rebase $base_branch from $main_branch...${NC}"
        git checkout "$base_branch"
        git rebase "$main_branch"
        git push --force-with-lease origin "$base_branch"
    fi
    
    # Step 3: Rebase current branch from updated base branch
    echo -e "${YELLOW}Step 3: Rebase $current_branch from $base_branch...${NC}"
    git checkout "$current_branch"
    git rebase "$base_branch"
    
    # Pop stash if there were changes
    if [[ -n "$(git stash list)" ]]; then
        git stash pop
    fi
    
    echo -e "${GREEN}Successfully completed cascade rebase${NC}"
}

# Show last commits for main, A, and B
showLastCommits() {
    local current_branch="$(_getCurrentBranch)"
    local base_branch="$(_getBaseBranch "$current_branch")"
    
    echo -e "${BLUE}=== Last Commits ===${NC}"
    
    # Show main/master last commit
    local main_branch="main"
    if ! git show-ref --verify --quiet refs/heads/main; then
        if git show-ref --verify --quiet refs/heads/master; then
            main_branch="master"
        fi
    fi
    
    if [[ -n "$main_branch" ]]; then
        echo -e "${GREEN}$main_branch:${NC}"
        git log -1 --oneline "$main_branch"
    fi
    
    # Show base branch last commit
    if [[ -n "$base_branch" && "$base_branch" != "$main_branch" ]]; then
        echo -e "${YELLOW}$base_branch:${NC}"
        git log -1 --oneline "$base_branch"
    fi
    
    # Show current branch last commit
    echo -e "${BLUE}$current_branch:${NC}"
    git log -1 --oneline "$current_branch"
}

# Main function to handle all operations
git-manage() {
    case "$1" in
        "base"|"go-base")
            goToBase
            ;;
        "main"|"go-main")
            goToMain
            ;;
        "back"|"return")
            goBack
            ;;
        "rebase")
            rebaseFrom "$2"
            ;;
        "cascade"|"cascade-rebase")
            cascadeRebase
            ;;
        "commits"|"show-commits")
            showLastCommits
            ;;
        "help"|"-h"|"--help"|"")
            echo -e "${BLUE}Git Management Tool${NC}"
            echo -e "${GREEN}Usage: git-manage [command] [args...]${NC}"
            echo
            echo -e "${YELLOW}Commands:${NC}"
            echo -e "  base, go-base    - Go to base branch (stash + checkout)"
            echo -e "  main, go-main    - Go to main/master branch (stash + checkout)"
            echo -e "  back, return     - Return to previous branch"
            echo -e "  rebase <base>    - Rebase current branch from specified base"
            echo -e "  cascade          - Cascade rebase from main (A from main, B from A)"
            echo -e "  commits          - Show last commits for main, A, and B"
            echo -e "  help             - Show this help message"
            echo
            echo -e "${BLUE}Examples:${NC}"
            echo -e "  git-manage base           # Go to base branch"
            echo -e "  git-manage main           # Go to main/master branch"
            echo -e "  git-manage rebase main    # Rebase from main"
            echo -e "  git-manage cascade        # Cascade rebase"
            echo -e "  git-manage commits        # Show last commits"
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            echo -e "${BLUE}Use 'git-manage help' for usage information${NC}"
            return 1
            ;;
    esac
}

# Aliases for quick access
alias gb='git-manage base'
alias gmain='git-manage main'
alias gback='git-manage back'
alias grebase='git-manage rebase'
alias gcascade='git-manage cascade'
alias gcommits='git-manage commits'
alias ghelp='git-manage help'
