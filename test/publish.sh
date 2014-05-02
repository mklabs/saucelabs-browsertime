#!/bin/bash

cd $TRAVIS_BUILD_DIR

git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"

git fetch -q || exit 1

git checkout -b build-$TRAVIS_BUILD_NUMBER

echo "Branch set up to build-$TRAVIS_BUILD_NUMBER"
git status | exit 1
echo "Adding results"
git add results -f || exit 1
git add index.html || exit 1
git status || exit 1

git commit -m "Build #$TRAVIS_BUILD_NUMBER - Publishing $TRAVIS_COMMIT results\n\n$DEPLOY_URL/results/$TRAVIS_BUILD_NUMBER" || exit 1

echo "Merging b-$TRAVIS_BUILD_NUMBER -> $DEPLOY_BRANCH"
git checkout $DEPLOY_BRANCH || exit 1
git merge b-$TRAVIS_BUILD_NUMBER || exit 1

echo "Cleanup build branch: b-$TRAVIS_BUILD_NUMBER"
git branch -D b-$TRAVIS_BUILD_NUMBER

echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH || exit 1
echo "Published"
