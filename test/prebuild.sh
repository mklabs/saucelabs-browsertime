#!/bin/bash
#
# https://raw.githubusercontent.com/medevice-users/gallery/master/prebuild.sh

echo "BUMP HELLO WORLD set up $GH_REPO [via travis] for $GIT_NAME <${GIT_EMAIL}>"
export REPO_URL="https://$GH_TOKEN@github.com/$GH_REPO.git"
git remote rm old || echo ""
git config --unset remote.origin.url || echo ""
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"
git branch -a
echo "STATUS"
git status
git remote rename origin old
echo "remotes pre pre-authorized remote url"
git remote -v
git remote add origin $REPO_URL
git config remote.origin.url $REPO_URL
