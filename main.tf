# aws-datadog-integration

/* Other options:
Limits:
Budget only from master account

Additional Config
Log collection
- https://docs.datadoghq.com/integrations/amazon_web_services/#log-collection
ECS https://docs.datadoghq.com/integrations/amazon_ecs/
- Run DD agent on each instance
https://docs.datadoghq.com/integrations/amazon_elasticache/
https://docs.datadoghq.com/integrations/amazon_rds/
https://docs.datadoghq.com/integrations/amazon_s3/#configuration
*/

module "enabled" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.2"
  value   = "${var.enabled}"
}

module "enable_autoscaling" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.enable_autoscaling}"
}

module "enable_cloudtrail" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.enable_cloudtrail}"
}

module "enable_logging" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.enable_logging}"
}

# https://docs.datadoghq.com/integrations/amazon_web_services/#installation
data "aws_iam_policy_document" "datadog_policy" {
  count = "${module.enabled.value}"

  statement {
    sid       = "${var.policy_name}"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:Describe*",
      "budgets:ViewBudget",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ec2:Get*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:List*",
      "logs:Get*",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:TestMetricFilter",
      "rds:Describe*",
      "rds:List*",
      "route53:List*",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "support:*",
      "tag:getResources",
      "tag:getTagKeys",
      "tag:getTagValues",
    ]
  }
}

# https://docs.datadoghq.com/integrations/amazon_auto_scaling/#configuration
data "aws_iam_policy_document" "autoscaling" {
  count = "${module.enabled.value && module.enable_autoscaling.value ? 1 : 0}"

  statement {
    sid       = "${var.autoscaling_policy_name}"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:ExecutePolicy",
    ]
  }
}

# https://docs.datadoghq.com/integrations/amazon_cloudtrail/#metric-collection
data "aws_iam_policy_document" "cloudtrail_log_bucket" {
  count = "${module.enabled.value && module.enable_cloudtrail.value ? 1 : 0}"

  statement {
    sid    = "${var.cloudtrail_policy_name}"
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListObjects",
    ]

    resources = [
      "${var.aws_cloudtrail_bucket_arn}",
      "${var.aws_cloudtrail_bucket_arn}/*",
    ]
  }
}

#"arn:aws:s3:::your-s3-cloudtrail-bucket-name",
#"arn:aws:s3:::your-s3-cloudtrail-bucket-name/*"

# https://docs.datadoghq.com/integrations/amazon_web_services/#send-aws-service-logs-to-datadog
data "aws_iam_policy_document" "logging" {
  count = "${module.enabled.value && module.enable_logging.value ? 1 : 0}"

  statement {
    sid       = "${var.logging_policy_name}"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:RemovePermission",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
    ]
  }
}

data "aws_iam_policy_document" "datadog_role" {
  count = "${module.enabled.value}"

  statement {
    sid     = "${var.role_name}"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.datadog_aws_account}:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${var.datadog_external_id}"]
    }
  }
}

resource "aws_iam_policy" "datadog" {
  count       = "${module.enabled.value}"
  name        = "${var.policy_name}"
  description = "Policy for Datadog standard integration"
  path        = "${var.policies_path}"
  policy      = "${data.aws_iam_policy_document.datadog_policy.json}"
}

resource "aws_iam_policy" "datadog_autoscaling" {
  count       = "${module.enabled.value && module.enable_autoscaling.value ? 1 : 0}"
  name        = "${var.autoscaling_policy_name}"
  description = "Policy for Datadog autoscaling integration"
  path        = "${var.policies_path}"
  policy      = "${data.aws_iam_policy_document.autoscaling.json}"
}

resource "aws_iam_policy" "datadog_cloudtrail" {
  count       = "${module.enabled.value && module.enable_cloudtrail.value ? 1 : 0}"
  name        = "${var.cloudtrail_policy_name}"
  description = "Policy for Datadog Cloudtrail integration"
  path        = "${var.policies_path}"
  policy      = "${data.aws_iam_policy_document.cloudtrail_log_bucket.json}"
}

resource "aws_iam_policy" "datadog_logging" {
  count       = "${module.enabled.value && module.enable_logging.value ? 1 : 0}"
  name        = "${var.logging_policy_name}"
  description = "Policy for Datadog Logging integration"
  path        = "${var.policies_path}"
  policy      = "${data.aws_iam_policy_document.logging.json}"
}

resource "aws_iam_role" "datadog" {
  count              = "${module.enabled.value}"
  name               = "${var.role_name}"
  description        = "Datadog integration role"
  path               = "${var.role_path}"
  assume_role_policy = "${data.aws_iam_policy_document.datadog_role.json}"
}

resource "aws_iam_role_policy_attachment" "datadog" {
  count      = "${module.enabled.value}"
  role       = "${aws_iam_role.datadog.name}"
  policy_arn = "${aws_iam_policy.datadog.arn}"
}

resource "aws_iam_role_policy_attachment" "datadog_autoscaling" {
  count      = "${module.enabled.value && module.enable_autoscaling.value ? 1 : 0}"
  role       = "${aws_iam_role.datadog.name}"
  policy_arn = "${aws_iam_policy.datadog_autoscaling.arn}"
}

resource "aws_iam_role_policy_attachment" "datadog_cloudtrail" {
  count      = "${module.enabled.value && module.enable_cloudtrail.value ? 1 : 0}"
  role       = "${aws_iam_role.datadog.name}"
  policy_arn = "${aws_iam_policy.datadog_cloudtrail.arn}"
}

resource "aws_iam_role_policy_attachment" "datadog_logging" {
  count      = "${module.enabled.value && module.enable_logging.value ? 1 : 0}"
  role       = "${aws_iam_role.datadog.name}"
  policy_arn = "${aws_iam_policy.datadog_logging.arn}"
}
