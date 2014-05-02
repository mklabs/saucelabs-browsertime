#!/bin/bash

cd $TRAVIS_BUILD_DIR

git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"

git fetch -q || exit 1

git branch $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || exit 1
git checkout $DEPLOY_BRANCH || exit 1
echo "Branch set up to origin/$DEPLOY_BRANCH"
echo "Cd to Build #$TRAVIS_BUILD_NUMBER directory"

cd results/$TRAVIS_BUILD_NUMBER || exit 1
ls -la || exit 1

git add . -f || exit 1
git status || exit 1
git commit -m "Configure Travis to build and publish site" || exit 1
echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH || exit 1
echo "Published"
