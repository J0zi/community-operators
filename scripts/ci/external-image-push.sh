#!/usr/bin/env bash
#This scripts is configured in .circleci/config.yml

set -e #fail in case of non zero return

#TODO: check
COMMIT=$(git --no-pager log -n1 --format=format:"%H" | tail -n 1)
echo
echo "Target commit $COMMIT"

echo "git log"
git --no-pager log --oneline|head
echo
echo "Source commit details:"
git --no-pager log -m -1 --name-only --first-parent $COMMIT

declare -A CHANGED_FILES
##community only
echo "changed community files:"
CHANGED_FILES=$(git --no-pager log -m -1 --name-only --first-parent $COMMIT|grep -v 'upstream-community-operators/'|grep 'community-operators/') || { echo '******* No community operator (Openshift) modified, no reason to deploy on Openshift *******'; DO_NOT_RUN=true; exit 0; }
echo

echo "DO_NOT_RUN=$DO_NOT_RUN"
if [ "$DO_NOT_RUN" = false ] ; then

  for sf in ${CHANGED_FILES[@]}; do
    echo $sf
    if [ $(echo $sf| awk -F'/' '{print NF}') -ge 4 ]; then
        OP_NAME="$(echo "$sf" | awk -F'/' '{ print $2 }')"
        OP_VER="$(echo "$sf" | awk -F'/' '{ print $3 }')"
    fi
  done
  echo
  echo "OP_NAME=$OP_NAME"
  echo "OP_VER=$OP_VER"

  #detection end

  mkdir -p /tmp/.ansible-pulled
  cd /tmp/.ansible-pulled
#  ansible-pull -d /tmp/.ansible-pulled -vv -U https://github.com/J0zi/operator-test-playbooks -C RHO-716-deploy-on-openshift -vv -i localhost, deploy-olm-operator-openshift-upstream.yml -e ansible_connection=local -e package_name=$OP_NAME -e operator_dir=$TARGET_PATH/$OP_NAME -e op_version=$OP_VER
  echo "Variable summary:"
  echo "OP_NAME=$OP_NAME"
  echo "OP_VER=$OP_VER"

fi