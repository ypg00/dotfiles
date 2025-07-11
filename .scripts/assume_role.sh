#!/usr/bin/env bash

export ROLE_ARN=$1
CREDS=$(aws sts assume-role --profile dev --role-arn $ROLE_ARN --role-session-name local-testing)
export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)
aws sts get-caller-identity
