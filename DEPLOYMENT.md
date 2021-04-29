# Deployment

## Build the base image

```bash
docker build -f docker/base/Dockerfile -t user-metadata-form_base .
```

## Create the ECR repository (if necessary)

If an ECR repository named `maap-umf` doesn't already exist in the target AWS account,
then you need to [create it](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html).

## Pushing the docker image to ECR

Set the environment variables stated in the `.env.example` file

`AWS_ACCOUNT`: AWS Account number
`AWS_REGION`: AWS Region
`ENV`: Deployment environment (`sit`, `uat`, `production`)

Run:

```bash
./ecr-deploy.sh
```

This will push the docker image to the ECR repository with tag `maap-umf:${ENV}`.

### Deploying the User-Metadata-Form app

Instructions in [maap-data-system-services](https://github.com/MAAP-Project/maap-data-system-services/blob/main/DEPLOYMENT.md#5-umf-prep)
