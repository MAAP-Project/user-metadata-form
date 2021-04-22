# Deployment
### Pushing the docker image to ECR

Set the environment variables stated in the `.env.example` file

`AWS_ACCOUNT`: AWS Account number
`AWS_REGION`: AWS Region
`ENV`: Deployment environment (`sit`, `uat`, `production`)

Run:
``` 
./ecr-deploy.sh
```

This will push the docker image to the ECR repository with tag `maap-umf:${ENV}`.

### Deploying the User-Metadata-Form app

Instructions in [maap-data-system-services]()
