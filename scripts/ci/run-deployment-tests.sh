#!/bin/bash

eval $(scripts/ci/operators-env)

if [[ -z "${IS_TESTABLE}" ]]; then

  echo "IS_TESTABLE in run-deployment-tests is $IS_TESTABLE"

  if [[ $IS_TESTABLE -eq 0 ]]; then
   echo "Nothing was changed, not running the CI."
    exit 0
  fi
else
  if [ -z "${OP_PATH}" ] ;
  then
    echo "No operator modification detected. Exiting."
    exit 0 
  else
    echo "Detected modified Operator in ${OP_PATH}"
    echo "Detected modified Operator version ${OP_VER}"
  fi
      
  make operator.install OP_PATH="${OP_PATH}" OP_VER="${OP_VER}"
fi