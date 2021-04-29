#!/bin/bash

set -e

log () {
  local bold=$(tput bold)
  local normal=$(tput sgr0)
  echo "${bold}${1}${normal}" 1>&2;
}

if [ -z "${AWS_ACCOUNT}" ];
then
  log "Missing a valid AWS_ACCOUNT env variable";
  exit 1;
else
  log "Using AWS_ACCOUNT '${AWS_ACCOUNT}'";
fi

AWS_REGION=${AWS_REGION:-us-east-1}
REPO_NAME="maap-umf"

log "🔑 Authenticating..."
aws ecr get-login-password \
  --region "${AWS_REGION}" \
  | docker login \
    --username AWS \
    --password-stdin \
    "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

log "📦 Building image..."
docker build -f docker/app/Dockerfile -t "${REPO_NAME}:${ENV}" .

log "🏷️ Tagging image..."
docker tag \
  "${REPO_NAME}:${ENV}" \
  "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${ENV}"

log "🚀 Pushing to ECR repo..."
docker push \
  "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${ENV}"

log "💃 Deployment Successful. 🕺"
