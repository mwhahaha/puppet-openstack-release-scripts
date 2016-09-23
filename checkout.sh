#!/bin/bash
source functions.sh

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  if [ ! -d "${M}" ]; then
    git clone https://github.com/openstack/${M}.git
  else
    pushd "${M}"
    git checkout master
    popd
  fi
done
