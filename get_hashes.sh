#!/bin/bash
source functions.sh

set +x
check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  pushd "${M}"
  HASH=$(git rev-parse HEAD)
  echo "${M}: ${HASH}"
  popd
done
