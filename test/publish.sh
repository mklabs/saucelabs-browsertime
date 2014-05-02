

git remote set-branches --add origin $DEPLOY_BRANCH
git fetch -q
git branch $DEPLOY_BRANCH origin/$DEPLOY_BRANCH
git add .
git commit -m "Configure Travis to build and publish site"
git push origin $DEPLOY_BRANCH
