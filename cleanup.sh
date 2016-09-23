#!/bin/bash
source functions.sh

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  if [ -d "${M}" ]; then
    rm -rf "${M}"
  else
    echo "${M} is not currently checkout out"
  fi
done
