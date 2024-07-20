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

mkdir $basename
cd "$basename"

# Moves all the administrative git files (a.k.a $GIT_DIR) under .git-bare directory.
#
# Plan is to create worktrees as siblings of this directory.
# Example targeted structure:
# .git-bare
# dev-tree
# alt-tree


# When cloning only fetch the main single branch to local, fetch all remotes
git clone --bare --single-branch "$url" .git-bare
echo "gitdir: ./.git-bare" > .git

# Explicitly sets the remote origin fetch so we can fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# Gets all branches from origin without fetching them locally
git fetch origin

# Create main worktree
git worktree add ./dev-tree dev

rm .git # rm .git file since a work-tree has been added

# Append each item in the IGNORE array to the exclude file
IGNORE=(".venv" "poetry.lock")
exclude_file=".git-bare/info/exclude"
for item in "${IGNORE[@]}"; do
  echo "$item" >> "$exclude_file"
done
