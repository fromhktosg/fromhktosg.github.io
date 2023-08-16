#!/bin/bash

# Get the current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %T")

# Function for updating and publishing the page
echo "Syncing latest code from source and master..."
# git pull origin source
# git pull origin master

echo "Switching to source branch to make changes..."
git checkout source
git add --all
git commit -m "Changes made at $TIMESTAMP"
git push origin source

# echo "Building the website..."
# bundle exec jekyll build

# echo "Switching to master branch to publish the updated site..."
# git checkout master

# # Optionally, uncomment the following line to reset if necessary
# # ls | grep -v '^_site$' | xargs rm -r

# cp -r _site/* .
# git add .
# git commit -m "Updated site version at $TIMESTAMP"
# git push origin master
# git push origin source
# git checkout source