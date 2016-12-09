#!/bin/bash
source functions.sh

BRANCH=${1:-'master'}

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  echo "Checking out ${BRANCH} of ${M}..."
  if [ ! -d "${M}" ]; then
    git clone https://github.com/openstack/${M}.git -b $BRANCH $M
  else
    pushd "${M}"
    git checkout ${BRANCH}
    popd
  fi
done
