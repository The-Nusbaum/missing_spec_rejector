#!/bin/bash

function get_files {
  files=$(git --no-pager diff --name-only remotes/origin/$TARGET)
}

function iterate_files {
  echo "Files found, iterating for *.spec files"
  specs=0
  IFS=' ' read -r -a files <<< "$files"
  for file in $files; do
    echo "checking:" $file
    if [[ $file =~ .*_spec\.rb ]]; then
      specs=$(($specs + 1))
    fi
  done
  if [[ $specs = 0 ]]; then
    echo "No spec files found."
    result=1
  else
    echo "Spec files found"
    result=0
  fi
}

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"

echo "BRANCH:" $BRANCH
echo "TARGET:" $TARGET

echo "Fetching..."
git fetch --all --prune-tags > /dev/null 2>&1
echo "...done"

echo "checking out " $BRANCH
git checkout $BRANCH
echo "...done"

get_files

if [ -z "$files" ];
then
  echo "Nothing Found";
  exit $?
else
  iterate_files
fi
echo "------------- Script Ending ----------------------"
exit $result
