#!/bin/bash
source functions.sh

BRANCH=${1:-'master'}

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  pushd "${M}"
    git review $BRANCH
  popd
done
