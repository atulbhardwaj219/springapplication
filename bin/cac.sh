#!/usr/bin/env bash
set -eu -o pipefail


if [ -n "${AWS_ROLE}" ]
then
    CREDS=$(aws sts assume-role --role-arn "${AWS_ROLE}" --role-session-name "github-buiulder" --query "Credentials" --output text)
    read id exp key token <<<$CREDS
    export AWS_ACCESS_KEY_ID=$id
    export AWS_SECRET_ACCESS_KEY=$key
    export AWS_SESSION_TOKEN=$token

fi

sudo docker build -t spring --build-arg version="1.2" 

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 357022024302.dkr.ecr.us-east-1.amazonaws.com

sudo docker tag spring:latest 357022024302.dkr.ecr.us-east-1.amazonaws.com/post:latest

docker push 357022024302.dkr.ecr.us-east-1.amazonaws.com/post:latest
