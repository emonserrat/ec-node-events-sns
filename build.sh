#!/bin/bash

set -e

PYTHON_VERSION=${PYTHON_VERSION:-3.7}
PROJECT_NAME=prd-ec-node-events-sns
BUILD_PREFIX=./build

AWS_REGION=${AWS_REGION:-us-east-1}
AWS_PROFILE=${AWS_PROFILE:-default}

[ ! -d ${BUILD_PREFIX} ] && mkdir ${BUILD_PREFIX}

# Add relevant code to build directory
cp -r \
  ./aws_lambda.py \
  ${BUILD_PREFIX}

rm -f ${PROJECT_NAME}.zip
find ./ -type f -name "*.pyc" -exec rm -f \{} \;
find ./ -type d -name "__pycache__" -exec rm -rf \{} \;

# Build zip package to be deployed to AWS
pushd ${BUILD_PREFIX} && zip -r ../${PROJECT_NAME}.zip ./ -x "*.pyc" "*.swa" "*.swp" && popd

aws lambda update-function-code \
  --profile ${AWS_PROFILE} \
  --function-name ${PROJECT_NAME} \
  --zip-file fileb://${PROJECT_NAME}.zip \
  --region ${AWS_REGION}
