#!/bin/bash

cd $TRAVIS_BUILD_DIR

git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"

git fetch -q || exit 1

echo "Branch set up to build-$TRAVIS_BUILD_NUMBER"
git status | exit 1
echo "Adding results"
ls -la results || exit 1
git add results -f || exit 1
git add index.html || exit 1
git status || exit 1

git checkout -b $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || git checkout $DEPLOY_BRANCH || exit 1

git status

git commit -F- <<EOF
Travis publish $TRAVIS_COMMIT results ($TRAVIS_BUILD_NUMBER)

$DEPLOY_URL/results/$TRAVIS_BUILD_NUMBER
EOF

git status

echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH -q || exit 1
echo "Published"
