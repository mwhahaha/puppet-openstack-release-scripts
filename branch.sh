#!/bin/bash
set -xe

TOPICNAME=$1
if [ -z "${TOPICNAME}" ]; then
  echo "usage: $0 <topicname>"
  exit 1
fi

source functions.sh

check_file_list

for M in `cat puppet-openstack-release-list.txt `; do
  check_dir "${M}"
  pushd "${M}"
  git_create_branch "${TOPICNAME}"
  popd
done
