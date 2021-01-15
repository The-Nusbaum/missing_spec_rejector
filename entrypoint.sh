#!/bin/bash

function get_files {
  files=$(git --no-pager diff --name-only remotes/origin/$TARGET)
}

function iterate_files {
  echo "Files found, iterating for *.spec files"
  specs=0
  IFS=' ' read -r -a mlfiles <<< "$files"
  for file in $mlfiles; do
    echo "checking:" $file
    if [[ $file =~ .*_spec\.rb ]]; then
      specs=$(($specs + 1))
    fi
  done
}

function count_specs {
  specs=$(echo $files| tr ' ' '\n' | grep '_spec.rb' -c)
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
git --no-pager diff --name-only remotes/origin/$TARGET
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
