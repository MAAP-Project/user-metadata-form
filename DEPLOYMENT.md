# Deployment

## Build the base image

```bash
docker build -f docker/base/Dockerfile -t user-metadata-form_base .
```

## Create the AWS Elastic Container Registry (ECR) repository (if necessary)

If an ECR repository named `maap-umf` doesn't already exist in the target AWS account,
then you need to [create it](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html).

## Pushing the docker image to ECR

Set environment variables.

**Make sure to update `ENV` in setenv.sh** `ENV` hould likely be `production` but any of the environment names listed in `config/database.yml` should be valid. Note that `ENV` is also used to tag the ECR image so this value will need to be set as the image tag when deploying the AWS ECS Service.

```bash
export AWS_PROFILE=XXX
source setenv.sh
```

Deploy:

```bash
./ecr-deploy.sh
```

This will push the docker image to the ECR repository with tag `maap-umf:${ENV}`.

### Deploying the User-Metadata-Form app

Instructions in [maap-data-system-services](https://github.com/MAAP-Project/maap-data-system-services/blob/main/DEPLOYMENT.md#5-umf-prep)
