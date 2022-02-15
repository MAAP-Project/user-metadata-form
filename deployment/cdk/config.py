"""UMF Stack Configs."""

from typing import Optional

import pydantic


class StackSettings(pydantic.BaseSettings):
    """Application settings"""

    name: str = "maap-umf"
    stage: str = "production"

    owner: Optional[str]
    client: Optional[str]

    # AWS ECS settings
    min_ecs_instances: int = 2
    max_ecs_instances: int = 10
    task_cpu: int = 1024
    task_memory: int = 2048

    # Necessary for HTTPS load balancer
    certificate_arn: str

    # For GCC deployments
    permissions_boundary_name: Optional[str]
    vpc_id: Optional[str]

    class Config:
        """model config"""

        env_file = ".env"
        env_prefix = "UMF_STACK_"
