#!/bin/bash

# Get the current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %T")

# Function to serve and test locally
echo "Switching to source branch and starting Jekyll..."
git checkout source
<<<<<<< HEAD
jekyll serve --watch --port 4001
=======
bundle exec jekyll serve --watch --port 4001
>>>>>>> c383874c28d6536aaeef387bbb5b666ab8c5d893
