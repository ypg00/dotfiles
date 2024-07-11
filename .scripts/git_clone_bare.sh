#!/usr/bin/env bash
# From https://morgan.cugerone.com/blog/workarounds-to-git-worktree-using-bare-repository-and-cannot-fetch-remote-branches/

# This script is meant to help set up cloneing bare directories for worktree-based workflow
# Sets .git-bare as the git directory

# Examples of call:
# git-clone-bare git@github.com:name/repo.git
# => Clones to a /repo.git directory
#
# git-clone-bare-for-worktrees git@github.com:name/repo.git my-repo
# => Clones to a /my-repo directory

set -e

url=$1
basename=${url##*/}
# name=${2:-${basename%.*}}

mkdir $basename
cd "$basename"

# Moves all the administrative git files (a.k.a $GIT_DIR) under .git-bare directory.
#
# Plan is to create worktrees as siblings of this directory.
# Example targeted structure:
# .git-bare
# main
# new-awesome-feature
# hotfix-bug-12
# ...


# When cloning only fetch the main single branch to local, fetch all remotes
git clone --bare --single-branch "$url" .git-bare
echo "gitdir: ./.git-bare" > .git

# Explicitly sets the remote origin fetch so we can fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# Gets all branches from origin without fetching them locally
git fetch origin

# Create main worktree
git worktree add ./dev-tree dev

# Create alt worktree
git worktree add ./alt-tree -b alt-branch
