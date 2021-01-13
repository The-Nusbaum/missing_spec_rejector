#!/bin/bash

function get_current_info {
  branch=$(git rev-parse --abbrev-ref HEAD)
  current_branch=${TRIGGER:=$branch}
  echo "Trigger:" $current_branch
}

function get_files {
  files=$(git --no-pager diff --name-only FETCH_HEAD)
}

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"
echo "TRIGGERING BRANCH:" $TRIGGER
get_current_info

git fetch --prune-tags

git checkout $branch

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
