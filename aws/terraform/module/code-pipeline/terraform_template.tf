{
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
    "aws_codebuild_project": {
      "nextgenapp_build": {
        "artifacts": [
          {
            "type": "CODEPIPELINE"
          }
        ],
        "build_timeout": "20",
        "environment": [
          {
            "compute_type": "BUILD_GENERAL1_SMALL",
            "image": "aws/codebuild/docker:1.12.1",
            "privileged_mode": true,
            "type": "LINUX_CONTAINER"
          }
        ],
        "name": "nextgenapp-codebuild",
        "service_role": "${aws_iam_role_codebuild_role_arn}",
        "source": [
          {
            "buildspec": "${data_template_file_buildspec_rendered}",
            "type": "CODEPIPELINE"
          }
        ]
      }
    },
    "aws_codepipeline": {
      "pipeline": {
        "artifact_store": [
          {
            "location": "${aws_s3_bucket.source.bucket}",
            "type": "S3"
          }
        ],
        "name": "nextgen-pipeline",
        "role_arn": "${aws_iam_role_codepipeline_role_arn}",
        "stage": [
          {
            "action": {
              "category": "Source",
              "configuration": {
                "Branch": "master",
                "Owner": "${var.git_org}",
                "Repo": "${var.git_project}"
              },
              "name": "Source",
              "output_artifacts": [
                "source"
              ],
              "owner": "ThirdParty",
              "provider": "GitHub",
              "version": "1"
            },
            "name": "Source"
          },
          {
            "action": {
              "category": "Build",
              "configuration": {
                "ProjectName": "nextgenapp-codebuild"
              },
              "input_artifacts": [
                "source"
              ],
              "name": "Build",
              "output_artifacts": [
                "imagedefinitions"
              ],
              "owner": "AWS",
              "provider": "CodeBuild",
              "version": "1"
            },
            "name": "Build"
          },
          {
            "action": {
              "category": "Deploy",
              "configuration": {
                "ClusterName": "${var.aws_ecs_cluster_name}",
                "FileName": "imagedefinitions.json",
                "ServiceName": "${var.aws_ecs_service_name}"
              },
              "input_artifacts": [
                "imagedefinitions"
              ],
              "name": "Deploy",
              "owner": "AWS",
              "provider": "ECS",
              "version": "1"
            },
            "name": "Production"
          }
        ]
      }
    }
  },
  "variable": {
    "access_key": {
      "description": "Provider AWS Access Key"
    },
    "aws_ecs_cluster_name": {
      "default": "tf_aws_ecs-cluster",
      "description": "AWS ECS Cluster name"
    },
    "aws_ecs_service_name": {
      "default": "tf_aws_service",
      "description": "AWS ECS Service name"
    },
    "aws_iam_role_codebuild_role_arn": {
      "description": "IAM Codebuild Role"
    },
    "aws_iam_role_codepipeline_role_arn": {
      "description": "IAM Codepipeline Role"
    },
    "data_template_file_buildspec_rendered": {
      "description": "Data Template File Buildspec"
    },
    "git_org": {
      "default": "icitv2",
      "description": "GIT URL Owner or Organization Name"
    },
    "git_project": {
      "default": "sample-jboss",
      "description": "GIT URL Project Name"
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