#!/bin/bash
source functions.sh

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  pushd "${M}"
    git review
  popd
done
