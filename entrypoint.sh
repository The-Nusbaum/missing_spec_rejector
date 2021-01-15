#!/bin/bash

function get_files {
echo "Getting File List."
  files=$(git --no-pager diff --name-only remotes/origin/$TARGET)
}

function count_specs {
  echo "Counting Files."
  specs=$(echo $files| tr ' ' '\n' | grep '_spec.rb' -c)
  echo $specs " specs found"
}

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"

echo "BRANCH:" $BRANCH
echo "TARGET:" $TARGET

echo "Fetching..."
git fetch --all --prune-tags > /dev/null 2>&1
echo "...done"

# echo "checking out " $BRANCH
# git checkout $BRANCH
# echo "...done"
get_files

if [ -z "$files" ];
then
  echo "Nothing Found";
  exit $?
else
  #iterate_files
  count_specs
  if [[ $specs = 0 ]]; then
    echo "No spec files found."
    result=1
  else
    echo "Spec files found"
    result=0
  fi
fi
echo "------------- Script Ending ----------------------"
exit $result
