# User Metadata Form Deployment

Deployment of the UMF uses the AWS CDK v1. Ignore the warning that AWS CDK v2 is available, until a proper
upgrade can be made of both this project and other CDK projects.

0. To deploy a new stage, You must also create an environment file in `config/environments/`, e.g.:

```bash
cp config/environments/dit.rb config/environments/aimee.rb
```

1. Initial setup

```bash
# clone User Metadata Form repo
git clone https://github.com/MAAP-Project/user-metadata-form

cd user-metadata-form/deployment

# create and activate python venv
python -m venv --prompt ${PWD##*/} .venv
source .venv/bin/activate

# install CDK dependencies
pip install -r requirements.txt
npm install
```

2. Conditional on the AWS account and region, run CDK bootstrap. This step is only necessary once per AWS account / region combination.

```bash
AWS_REGION=us-west-2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq .Account -r)
npm run cdk bootstrap aws://${AWS_ACCOUNT_ID}/${AWS_REGION}
```

3. Populate Secrets and Parameters

First, check if these secrets have been populated in AWS Secrets Manager. If not, create them as below.

Populate the per-stage parameters. These may already be populated, so first check in `AWS Console -> Systems Manager -> Parameter Store`. Set the `UMF_STACK_STAGE` variable to the appropriate stage, e.g., `dit`.

```bash
export UMF_STACK_STAGE=dit
export AWS_REGION=us-west-2

aws ssm put-parameter \
    --type "String" \
    --overwrite \
    --name "/${UMF_STACK_STAGE}-maap-umf/EARTHDATA_USERNAME" \
    --value "devseed"

aws ssm put-parameter \
    --type "SecureString" \
    --overwrite \
    --name "/${UMF_STACK_STAGE}-maap-umf/EARTHDATA_PASSWORD" \
    --value '<the password>'

aws ssm put-parameter \
    --type "String" \
    --overwrite \
    --name "/${UMF_STACK_STAGE}-maap-umf/CUMULUS_REST_API" \
    # TODO: Fetch this from api gateway via AWS CLI
    --value "https://z4eaw8vft6.execute-api.us-west-2.amazonaws.com/dev/"

aws ssm put-parameter \
    --type "SecureString" \
    --overwrite \
    --name "/${UMF_STACK_STAGE}-maap-umf/SECRET_KEY_BASE" \
    --value '<the secret key base>'
```

4. Generate CloudFormation template

This step isn't required, but can be useful to just validate the configuration generates
a valid CloudFormation template.

```bash
export UMF_STACK_STAGE=dit
export AWS_REGION=us-west-2
npm run cdk synth
```

5. Set deployment configuration

The list of supported deployment configuration values can be found in [`cdk/config.py`](./cdk/config.py).

Configuration is managed via `pydantic` and can be specified as [outlined in their documentation](https://pydantic-docs.helpmanual.io/usage/settings/).

Whether you are using environment variables or an `.env` file to specify configuration, the
prefix for values should be `UMF_STACK_`. So to specify a value for the `stage` setting, you
would specify a `UMF_STACK_stage` value as an environment variable, in `.env`, or via any other
method supported by `pydantic`.

## Backing up deployment configuration to AWS SSM

We are using the [`pydantic-ssm-settings` package](https://github.com/developmentseed/pydantic-ssm-settings), which allows us to backup up our `pydantic` configuration values
specified via an `.env` file to AWS SSM and have them lazily loaded if no other value is
specified for a setting.

To backup configuration from `.env` to SSM (where `<stage-name>` is `production`, `dit`, etc and should match the `UMF_STACK_stage` for your deployment):

```shell
python scripts/dotenv-to-ssm.py .env /<stage-name>/umf
```

Once the configuration has been backed up to SSM, any value stored in SSM will be automatically
read by your deployment if it is not specified otherwise. Ideally, once a deployment has been
performed and its configuration has been backed up to SSM, subsequent deployments should only
need to specify new or changing configuration.

You will need to specify the stage name (`UMF_STACK_stage`) either via `.env` or environment
variable in order for the SSM integration to work.

If you make any configuration change to a deployment that you intend to be permanent, you
should re-run the above command to back up the configuration to SSM.

6. Deploy the App

This step deploy the application stack.

```bash
export UMF_STACK_STAGE=dit
export AWS_REGION=us-west-2
export CDK_DEPLOY_ACCOUNT=$(aws sts get-caller-identity | jq .Account -r)
export CDK_DEPLOY_REGION=us-west-2

npm run cdk deploy -- --require-approval never
```

This application stack contains a Postgres database, generates a Docker image for the application, configures an ECS Task Definition that uses that image, creates an ECS Service that uses that Task Definition, configures an application load balancer (ALB) to point to the ECS Service, and configures a custom DNS entry for the service.

7. Undeploy (optional)

```bash
export CDK_DEPLOY_ACCOUNT=$(aws sts get-caller-identity | jq .Account -r)
export CDK_DEPLOY_REGION=$(aws configure get region)

npm run cdk destroy
```
