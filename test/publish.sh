#!/bin/bash


git remote set-branches --add origin $DEPLOY_BRANCH || exit 1
git fetch -q || exit 1
git branch $DEPLOY_BRANCH origin/$DEPLOY_BRANCH || exit 1
cd results/last || exit 1
git add . -f || exit 1
git commit -m "Configure Travis to build and publish site" || exit 1
git push origin $DEPLOY_BRANCH || exit 1
