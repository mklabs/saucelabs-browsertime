#!/bin/bash

cd $TRAVIS_BUILD_DIR

git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"

git fetch -q || exit 1

git branch $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || exit 1
git checkout $DEPLOY_BRANCH || exit 1
echo "Branch set up to origin/$DEPLOY_BRANCH"
echo "Cd to Build #$TRAVIS_BUILD_NUMBER directory"

git add results -f || exit 1
git add index.html || exit 1

git status || exit 1
git commit -m "Build #$TRAVIS_BUILD_NUMBER - Publishing $TRAVIS_COMMIT results\n\n$DEPLOY_URL/results/$TRAVIS_BUILD_NUMBER" || exit 1
echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH || exit 1
echo "Published"
