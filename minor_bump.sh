#!/bin/bash
set -xe

TOPICNAME=$1
if [ -z "${TOPICNAME}" ]; then
  echo "usage: $0 <topicname>"
  exit 1
fi

source functions.sh

check_file_list

cat <<EOF
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! You cannot run this more than once on already modified modules !
! So make sure you have a clean set of modules before bumping.   !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

RELNOTES='releasenotes/source/conf.py'
METADATA='metadata.json'

for M in `cat puppet-openstack-release-list.txt `; do
  check_dir "${M}"
  pushd "${M}"
  git_create_branch "${TOPICNAME}"
  CURRENT_TAG=$(get_latest_tag)
  NEW_TAG=$(increment_tag_minor "$CURRENT_TAG")
  # update release notes config
  if [ -f "${RELNOTES}" ]; then
    sed -i -e "s/version = '${CURRENT_TAG}'/version = '${NEW_TAG}'/" $RELNOTES
    sed -i -e "s/release = '${CURRENT_TAG}'/release = '${NEW_TAG}'/" $RELNOTES
  fi

  # update metadata
  cat "$METADATA" | jq -f ../metadata_minor_version_bump.jq > "${METADATA}.new"
  mv "${METADATA}.new" "$METADATA"

  popd
done
