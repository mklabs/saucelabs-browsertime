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

git commit -F- <<EOF
Travis publish $TRAVIS_COMMIT results ($TRAVIS_BUILD_NUMBER)

$DEPLOY_URL/results/$TRAVIS_BUILD_NUMBER
EOF

echo "Merging build-$TRAVIS_BUILD_NUMBER -> $DEPLOY_BRANCH"
git checkout $DEPLOY_BRANCH || exit 1
git merge build-$TRAVIS_BUILD_NUMBER -s recursive -X theirs -m "Travis merge build $TRAVIS_BUILD_NUMBER" || exit 1

echo "Cleanup build branch: b-$TRAVIS_BUILD_NUMBER"
git branch -D build-$TRAVIS_BUILD_NUMBER

git status
echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH -q || exit 1
echo "Published"
