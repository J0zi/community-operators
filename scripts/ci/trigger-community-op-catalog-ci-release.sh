#!/usr/bin/env bash

#This will push the application (operator) to Quay appregistry which serves for backwards compatibility

eval $(scripts/ci/app-reg-env)
echo $OP_PATH

PUSH_TO_QUAY="nothing-to-push"
if [[ $(echo $OP_PATH) = community* ]]; then
#    ansible-pull -vv -U $PLAYBOOK_REPO -C $PLAYBOOK_BRANCH $PLAYBOOK_VARS -e run_upstream=true --tags host_build,push_to_quay -e operator_dir=/tmp/community-operators-for-catalog/$OP_PATH -e quay_appregistry_api_token=$QUAY_APPREG_TOKEN
PUSH_TO_QUAY=$(echo $OP_PATH | awk -F'/' '{print $2}')
echo "$PUSH_TO_QUAY will be pushed to the old Appregistry"
else
    echo "No Openshift community-operators modified, nothing to push to old Quay AppRegistry"
fi

curl -s -X POST \
     -H "Content-Type: application/json" \
     -H "Accept: application/json" \
     -H "Travis-API-Version: 3" \
     -H "Authorization: token $FRAMEWORK_AUTOMATION_ON_TRAVIS"  \
     -d '{"request":{"branch":"master", "config": {"env": { "jobs": [ "PUSH_OPERATOR='$PUSH_TO_QUAY'" ] } }}}'  \
     https://api.travis-ci.com/repo/operator-framework%2Fcommunity-operator-catalog/requests
echo -e "\nRelease pipeline has been triggered on operator-framework/community-operator-catalog"
