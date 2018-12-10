#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "$0 [path to repo] (interactive mode)"
  echo "or"
  echo "$0 [path to repo] [branch to checkout]"
  exit -1
fi

cd $1
repo_fullname=`git rev-parse --show-toplevel`
repo_name=`basename $repo_fullname`
echo ""
echo "REPOSITORY: $repo_name"
current_branch=`git rev-parse --abbrev-ref HEAD`
echo "CURRENT BRANCH: $current_branch"


branches=`git branch -r --sort=refname | grep -v HEAD` 
branches=${branches//\*/}
branches=${branches//origin\//}

if [ $# -eq 2 ]; then
  if [[ $branches = *"$2"* ]]; then
    git checkout $2
    exit 0
  else
    exit -1
  fi
fi

echo "SELECT BRANCH TO CHECKOUT"
select branch in $branches;
do
git checkout $branch
exit
done
