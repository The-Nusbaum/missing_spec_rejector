#!/bin/bash

function get_files {
  files=$(git --no-pager diff --name-only FETCH_HEAD)
  echo "FILES:"
  echo $files
  echo "======"
}

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"

echo "BRANCH:" $BRANCH
echo "TARGET:" $TARGET

git fetch --prune-tags
git status
git --no-pager diff --name-only FETCH_HEAD


# git checkout $BRANCH
echo "vvvvvvvvvvvvvvvv"
git --no-pager diff --name-only remotes/origin/$branch remotes/origin/$target
echo "^^^^^^^^^^^^^^^^"
get_files

if [ -z "$files" ];
then
  echo "Nothing Found";
  exit $?
else
  echo "Files found, iterating for *.spec files"
  specs=0
  IFS=' ' read -r -a $files <<< $files
  for file in $files; do
    echo "checking:" $file
    if [[ $file =~ .*\.spec ]]; then
      specs=$(($specs + 1))
    fi
  done
  if [[ $specs = 0 ]]; then
    echo "No spec files found."
    echo "------------- Script Ending ----------------------"
    exit 1
  else
    echo "Spec files found"
    echo "------------- Script Ending ----------------------"
    exit 0
  fi
fi
