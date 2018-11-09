{
    "data": {
        "template_file": {
            "buildspec": {
                "template": "${file(\"./buildspec.yml\")}",
                "vars": [
                    {
                        "cluster_name": "${var.aws_ecs_cluster_name}",
                        "region": "${var.region}",
                        "repository_url": "${var.aws_ecr_repository}",
                        "security_group_ids": "[${var.aws_security_group_ecs_tasks}]",
                        "subnet_id": "${var.aws_subnet_private_ids}"
                    }
                ]
            },
            "codebuild_policy": {
                "template": "${file(\"./policies/codebuild_policy.json\")}",
                "vars": [
                    {
                        "aws_s3_bucket_arn": "${aws_s3_bucket.source.arn}"
                    }
                ]
            },
            "codepipeline_policy": {
                "template": "${file(\"./policies/codepipeline.json\")}",
                "vars": [
                    {
                        "aws_s3_bucket_arn": "${aws_s3_bucket.source.arn}"
                    }
                ]
            }
        }
    },
    "output": {
        "aws_iam_role_codebuild_role_arn": {
            "value": "${aws_iam_role.codebuild_role.arn}"
        },
        "aws_iam_role_codepipeline_role_arn": {
            "value": "${aws_iam_role.codepipeline_role.arn}"
        },
        "data_template_file_buildspec_rendered": {
            "value": "${data.template_file.buildspec.rendered}"
        }
    },
    "provider": {
        "aws": {
            "__DEFAULT__": {
                "access_key": "${var.access_key}",
                "region": "${var.region}",
                "secret_key": "${var.secret_key}"
            }
        }
    },
    "resource": {
        "aws_iam_role": {
            "codebuild_role": {
                "assume_role_policy": "${file(\"./policies/codebuild_role.json\")}",
                "name": "codebuild-role"
            },
            "codepipeline_role": {
                "assume_role_policy": "${file(\"./policies/codepipeline_role.json\")}",
                "name": "codepipeline-role"
            }
        },
        "aws_iam_role_policy": {
            "codebuild_policy": {
                "name": "codebuild-policy",
                "policy": "${data.template_file.codebuild_policy.rendered}",
                "role": "${aws_iam_role.codebuild_role.id}"
            },
            "codepipeline_policy": {
                "name": "codepipeline_policy",
                "policy": "${data.template_file.codepipeline_policy.rendered}",
                "role": "${aws_iam_role.codepipeline_role.id}"
            }
        },
        "aws_s3_bucket": {
            "source": {
                "acl": "private",
                "bucket": "app-migration-aws",
                "force_destroy": true
            }
        }
    },
    "variable": {
        "access_key": {
            "description": "Provider AWS Access Key"
        },
        "aws_ecr_repository": {
            "description": "AWS ECR One Repository Name"
        },
        "aws_ecs_cluster_name": {
            "default": "tf_aws_ecs-cluster",
            "description": "AWS ECS Cluster name"
        },
        "aws_security_group_ecs_tasks": {
            "description": "AWS Security Group ECS Tasks ID"
        },
        "aws_subnet_private_ids": {
            "description": "AWS Private Subnets"
        },
        "region": {
            "default": "us-east-1",
            "description": "The AWS region to create things in."
        },
        "secret_key": {
            "description": "Provider AWS Secret Key"
        }
    }
}