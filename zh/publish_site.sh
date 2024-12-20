#!/bin/bash

# Get the current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %T")

# Ensure the script exits on errors
set -e

echo "Ensuring all local changes on 'source' branch are committed before rebasing..."
git checkout source || { echo "Failed to switch to source branch. Exiting."; exit 1; }

# Stage all local changes, including new posts in i18n directories
git add --all
git add _i18n/en/_posts/ _i18n/zh/_posts/ 2>/dev/null || true

# Commit if there are changes
if git diff-index --quiet HEAD --; then
  echo "No local changes to commit on source branch."
else
  git commit -m "Local changes made at $TIMESTAMP"
fi

# Function to sync with a remote branch using rebase
sync_branch() {
  local branch=$1
  echo "Switching to branch '$branch'..."
  git checkout $branch || { echo "Failed to switch to branch '$branch'. Exiting."; exit 1; }
  
  echo "Pulling and rebasing latest changes for branch '$branch'..."
  git pull --rebase origin $branch || { echo "Rebase failed on '$branch'. Exiting."; exit 1; }
}

# Now that local changes are safely committed, we can rebase
sync_branch "source"
sync_branch "master"

# Get the last committed time of the master branch
LAST_COMMIT_TIME_MASTER=$(git log -1 --format="%cd" master)
echo "Last committed time of master: $LAST_COMMIT_TIME_MASTER"

echo "Switching back to source branch to make new changes..."
git checkout source || { echo "Failed to switch to source branch. Exiting."; exit 1; }

# Safeguard: Stage and commit any remaining changes (e.g., resolved conflicts or new files after rebase)
git add --all
if git diff --cached --quiet; then
  echo "No new changes to commit after rebase on source branch."
else
  git commit -m "Safeguard commit: Resolved conflicts or added changes at $TIMESTAMP"
fi

# Push changes to the source branch
echo "Pushing changes to source branch..."
git push origin source || { echo "Failed to push to source branch. Exiting."; exit 1; }

# Handle potential gem issues for Jekyll
echo "Configuring Ruby platform for Jekyll build..."
bundle config set force_ruby_platform true
bundle install || { echo "Bundle install failed. Exiting."; exit 1; }

echo "Building the website..."
bundle exec jekyll build || { echo "Jekyll build failed. Exiting."; exit 1; }

echo "Switching to master branch to publish the updated site..."
git checkout master || { echo "Failed to switch to master branch. Exiting."; exit 1; }

# Rebase master to ensure it's up-to-date
echo "Rebasing master branch with the latest changes..."
git pull --rebase origin master || { echo "Rebase failed on master. Exiting."; exit 1; }

# Copy the built website to the root
echo "Copying built site files to root directory..."
cp -r _site/* . || { echo "Failed to copy site files. Exiting."; exit 1; }

# Stage and commit changes for master branch
git add .
if git diff-index --quiet HEAD --; then
  echo "No changes to commit on master branch."
else
  git commit -m "Updated site version at $TIMESTAMP"
fi

# Push changes to the master branch
echo "Pushing changes to master branch..."
git push origin master || { echo "Failed to push to master branch. Exiting."; exit 1; }

# Switch back to the source branch
git checkout source || { echo "Failed to switch back to source branch. Exiting."; exit 1; }

echo "SUCCESS! Published website at $TIMESTAMP"