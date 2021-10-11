data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:getObject",
      "s3:GetObjectVersion",
      "s3:GetBacketVersioning",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:passRole",
    ]
  }
}