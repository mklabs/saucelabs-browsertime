#!/bin/bash

cd $TRAVIS_BUILD_DIR

git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"
git fetch -q || exit 1
git branch $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || exit 1
"Branch set up to origin/$DEPLOY_BRANCH"
cd results/last || exit 1
git add . -f || exit 1
git status || exit 1
git commit -m "Configure Travis to build and publish site" || exit 1
echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH || exit 1
echo "Published"
