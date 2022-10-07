"""Construct App."""

from ensurepip import version
import os
from os import path
from typing import Any, List, Optional, Union

from config import StackSettings

from aws_cdk import (
    core,
    aws_ec2 as ec2,
    aws_ecs as ecs,
    aws_rds as rds,
    aws_ecs_patterns as ecs_patterns,
    aws_ecr_assets as ecr_assets,
    aws_iam as iam,
    aws_elasticloadbalancingv2 as elb,
    aws_ssm as ssm,
    aws_certificatemanager as certificatemanager,
    aws_secretsmanager as secretsmanager
)

settings = StackSettings()

class UmfStack(core.Stack):
    """UMF ECS Fargate Stack."""

    def __init__(
        self,
        scope: core.Construct,
        stack_id: str,
        cpu: Union[int, float] = 1024,
        memory: Union[int, float] = 2048,
        mincount: int = 1,
        maxcount: int = 50,
        permissions: Optional[List[iam.PolicyStatement]] = None,
        env: Optional[core.Environment] = None,
        **kwargs: Any,
    ) -> None:
        """Define stack."""
        super().__init__(scope, stack_id, env=env, *kwargs)

        permissions = permissions or []

        app_port = 2998

        if settings.permissions_boundary_name is not None:
            boundary = iam.ManagedPolicy.from_managed_policy_name(
                self,
                'Boundary',
                settings.permissions_boundary_name
            )
            iam.PermissionsBoundary.of(self).apply(boundary)

        if settings.vpc_id is not None:
            vpc = ec2.Vpc.from_lookup(self, 'VPC', vpc_id=settings.vpc_id)
        else:
            vpc = ec2.Vpc(self, f"{stack_id}-vpc")

        db_admin_credentials_secret = rds.DatabaseSecret(
            self, f"/{stack_id}/UMF_STACK_AdminDBCredentials", username="postgres")
        task_env_secret = secretsmanager.Secret(self, "/dit-umf/task-env-vars")

        core.CfnOutput(self, "AdminDBCredentialsSecretName",
                       value=db_admin_credentials_secret.secret_name)
        core.CfnOutput(self, "AdminDBCredentialsSecretARN",
                       value=db_admin_credentials_secret.secret_arn)

        db_username = "umf"
        db_credentials_secret = rds.DatabaseSecret(
            self, f"/{stack_id}/UMF_STACK_AppDBCredentials", username=db_username)

        core.CfnOutput(self, "AppDBCredentialsSecretName",
                       value=db_credentials_secret.secret_name)
        core.CfnOutput(self, "AppDBCredentialsSecretARN",
                       value=db_credentials_secret.secret_arn)

        ingress_sg = ec2.SecurityGroup(self, f"{stack_id}-rds-ingress",
                                       vpc=vpc,
                                       security_group_name=f"{stack_id}-rds-ingress-sg",
                                       )

        ingress_sg.add_ingress_rule(
            # vpcCidrBlock refers to all the IP addresses in vpc
            ec2.Peer.ipv4(vpc.vpc_cidr_block),
            ec2.Port.tcp(5432),
            "Allows only local resources inside VPC to access this Postgres port (default -- 3306)"
        )

        # based on https://github.com/MAAP-Project/maap-data-system-services/blob/main/umf-db.tf
        db = rds.DatabaseInstance(
            self, "RDS",
            database_name="appdb",
            vpc=vpc,
            vpc_subnets=ec2.SubnetSelection(
                subnet_type=ec2.SubnetType.PRIVATE),
            security_groups=[ingress_sg],
            engine=rds.DatabaseInstanceEngine.postgres(
                version=rds.PostgresEngineVersion.VER_12_8),
            credentials=rds.Credentials.from_secret(
                db_admin_credentials_secret),
            port=5432,
            instance_type=ec2.InstanceType.of(
                ec2.InstanceClass.BURSTABLE2,
                ec2.InstanceSize.MEDIUM,
            ),
            allocated_storage=20,
            removal_policy=core.RemovalPolicy.DESTROY,
            deletion_protection=False,  # TODO: change to true!
            publicly_accessible=False,
        )

        core.CfnOutput(self, "DatabaseArn", value=db.instance_arn)
        core.CfnOutput(self, "DatabaseEndpointAddress",
                       value=db.db_instance_endpoint_address)
        core.CfnOutput(self, "DatabaseEndpointPort",
                       value=db.db_instance_endpoint_port)

        cluster = ecs.Cluster(
            self, f"{stack_id}-cluster", vpc=vpc, enable_fargate_capacity_providers=True)

        core.CfnOutput(self, "ClusterArn", value=cluster.cluster_arn)

        task_env = {}

        task_env["RAILS_LOG_TO_STDOUT"] = "true"
        task_env["LOG_LEVEL"] = "error"

        task_env["ENV"] = settings.stage
        task_env["RAILS_ENV"] = settings.stage

        # to serve css, etc., assets
        task_env["RAILS_SERVE_STATIC_FILES"] = "true"

        task_env["DATABASE_HOST"] = db.db_instance_endpoint_address
        task_env["DATABASE_NAME"] = "umf"
        task_env["DATABASE_USERNAME"] = db_username

        task_env["EARTHDATA_USERNAME"] = ssm.StringParameter.value_for_string_parameter(self, f"/{stack_id}/EARTHDATA_USERNAME")
        task_env["CUMULUS_REST_API"] = ssm.StringParameter.value_for_string_parameter(self, f"/{stack_id}/CUMULUS_REST_API")
        
        secret_earthdata_password = ssm.StringParameter.from_secure_string_parameter_attributes(self, id=f"/{stack_id}/EARTHDATA_PASSWORD", parameter_name=f"/{stack_id}/EARTHDATA_PASSWORD", version=5)
        secret_secret_key_base = ssm.StringParameter.from_secure_string_parameter_attributes(self, id=f"/{stack_id}/SECRET_KEY_BASE", parameter_name=f"/{stack_id}/SECRET_KEY_BASE", version=1)

        task_definition = ecs.FargateTaskDefinition(self, f"{stack_id}-task-definition",
                                                    cpu=cpu, memory_limit_mib=memory)

        task_definition.add_container(
            f"{stack_id}-container",
            image=ecs.ContainerImage.from_docker_image_asset(
                ecr_assets.DockerImageAsset(
                    self,
                    f"{stack_id}-image",
                    directory=path.abspath("../"),
                    file="deployment/Dockerfile"
                )
            ),
            port_mappings=[ecs.PortMapping(
                container_port=app_port, host_port=app_port)],
            secrets={
                "POSTGRES_PASSWORD": ecs.Secret.from_secrets_manager(db_admin_credentials_secret, "password"),
                "DATABASE_PASSWORD": ecs.Secret.from_secrets_manager(db_credentials_secret, "password"),
                "EARTHDATA_PASSWORD": ecs.Secret.from_ssm_parameter(secret_earthdata_password),
                "SECRET_KEY_BASE": ecs.Secret.from_ssm_parameter(secret_secret_key_base),
            },
            environment=task_env,
            logging=ecs.LogDrivers.aws_logs(stream_prefix=stack_id)
        )

        certificate = None
        certificate_arn = settings.certificate_arn
        if certificate_arn != None:
            certificate=certificatemanager.Certificate.from_certificate_arn(
                self,
                f"questionnaire.{settings.stage}.maap-project.org",
                certificate_arn
            )

        fargate_service = ecs_patterns.ApplicationLoadBalancedFargateService(
            self,
            f"{stack_id}-service",
            cluster=cluster,
            desired_count=mincount,
            public_load_balancer=True,
            protocol=elb.ApplicationProtocol.HTTPS,
            redirect_http=True,
            task_definition=task_definition,
            certificate=certificate
        )

        fargate_service.target_group.configure_health_check(
            port=str(app_port),
            unhealthy_threshold_count=5,
            healthy_threshold_count=2
        )

        for perm in permissions:
            fargate_service.task_definition.task_role.add_to_policy(perm)

        scalable_target = fargate_service.service.auto_scale_task_count(
            min_capacity=mincount, max_capacity=maxcount
        )

        # https://github.com/awslabs/aws-rails-provisioner/blob/263782a4250ca1820082bfb059b163a0f2130d02/lib/aws-rails-provisioner/scaling.rb#L343-L387
        scalable_target.scale_on_request_count(
            "RequestScaling",
            requests_per_target=50,
            scale_in_cooldown=core.Duration.seconds(240),
            scale_out_cooldown=core.Duration.seconds(30),
            target_group=fargate_service.target_group,
        )

        fargate_service.service.connections.allow_from_any_ipv4(
            port_range=ec2.Port(
                protocol=ec2.Protocol.ALL,
                string_representation="All port 80",
                from_port=80,
            ),
            description="Allows traffic on port 80 from ALB",
        )


app = core.App()


for key, value in {
    "Project": settings.name,
    "Stack": settings.stage,
    "Owner": settings.owner,
    "Client": settings.client,
}.items():
    if value:
        core.Tags.of(app).add(key, value)

print("STACK ID IS:")
print(f"{settings.stage}-{settings.name}")
UmfStack(
    scope=app,
    stack_id=f"{settings.stage}-{settings.name}",
    cpu=settings.task_cpu,
    memory=settings.task_memory,
    mincount=settings.min_ecs_instances,
    maxcount=settings.max_ecs_instances,
    permissions=[],
    env=core.Environment(
        account=os.environ.get(
            "CDK_DEPLOY_ACCOUNT", os.environ["CDK_DEFAULT_ACCOUNT"]),
        region=os.environ.get("CDK_DEPLOY_REGION", os.environ["CDK_DEFAULT_REGION"]))
)

app.synth()
