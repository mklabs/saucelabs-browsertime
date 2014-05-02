#!/bin/bash

cd $TRAVIS_BUILD_DIR
RESULT_DIR=results/$TRAVIS_BUILD_NUMBER

git fetch -q || exit 1
git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
echo "Remote set to $DEPLOY_BRANCH"

git checkout -b $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || git checkout $DEPLOY_BRANCH || exit 1
git status || exit 1

echo "... Generate  $RESULT_DIR/index.html ..."
node test/build-index.js $RESULT_DIR > $RESULT_DIR/index.html

echo "... Generate  results/index.html ..."
node test/build-index.js $RESULT_DIR index > results/index.html

echo "... Generate index.html ..."
node test/build-index.js $RESULT_DIR index readme.md > index.html

git status | exit 1

echo "Adding results"
git add results -f || exit 1
git add index.html || exit 1
git status || exit 1


git commit -F- <<EOF
Travis publish $TRAVIS_COMMIT results ($TRAVIS_BUILD_NUMBER)

$DEPLOY_URL/results/$TRAVIS_BUILD_NUMBER
EOF

git status

echo "Pushing to repo.."
git push origin $DEPLOY_BRANCH -q || exit 1
echo "Published"
