#!/bin/bash
check_file_list() {
  if [ ! -f "puppet-openstack-release-list.txt" ]; then
    echo "missing module list"
    exit 1
  fi
}

check_dir() {
  local DIR=$1
  if [ ! -d "${DIR}" ]; then
    echo "Missing directory ${DIR}"
    exit 1
  fi
}

get_latest_tag() {
  local HEAD=`git tag | sort -nr | head -1`
  if [ -z "${HEAD}" ]; then
    echo "No current tag in ${PWD}"
    exit 1
  fi
  echo "${HEAD}"
}

increment_tag_fixup() {
  local VERSION=$1
  if [ -z "${VERSION}" ]; then
    echo "No version provided to increment tag"
    exit 1
  fi
  parts=( ${VERSION//./ } )
  (( parts[2]++ ))
  echo "${parts[0]}.${parts[1]}.${parts[2]}"
}

increment_tag_minor() {
  local VERSION=$1
  if [ -z "${VERSION}" ]; then
    echo "No version provided to increment tag"
    exit 1
  fi
  parts=( ${VERSION//./ } )
  (( parts[1]++ ))
  echo "${parts[0]}.${parts[1]}.0"
}

increment_tag_major() {
  local VERSION=$1
  if [ -z "${VERSION}" ]; then
    echo "No version provided to increment tag"
    exit 1
  fi
  parts=( ${VERSION//./ } )
  (( parts[0]++ ))
  echo "${parts[0]}.0.0"
}

git_create_branch() {
    local TOPIC=$1
    if [ -z "${TOPIC}" ]; then
      echo "please provide topic to git_create_branch"
      exit 1
    fi
    git fetch --all
    git checkout master
    git checkout -b "${TOPIC}"
}
