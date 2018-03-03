output "autoscaling_policy_arn" {
  description = "Datadog autoscaling integration policy ARN"
  value       = "${element(concat(aws_iam_policy.datadog_autoscaling.*.arn, list("")), 0)}"
}

output "autoscaling_policy_name" {
  description = "Datadog autoscaling integration policy name"
  value       = "${element(concat(aws_iam_policy.datadog_autoscaling.*.arn, list("")), 0)}"
}

output "cloudtrail_policy_arn" {
  description = "Datadog Cloudtrail integration policy ARN"
  value       = "${element(concat(aws_iam_policy.datadog_cloudtrail.*.arn, list("")), 0)}"
}

output "cloudtrail_policy_name" {
  description = "Datadog Cloudtrail integration policy name"
  value       = "${element(concat(aws_iam_policy.datadog_cloudtrail.*.arn, list("")), 0)}"
}

output "policy_arn" {
  description = "Datadog standard integration policy ARN"
  value       = "${element(concat(aws_iam_policy.datadog.*.arn, list("")), 0)}"
}

output "policy_name" {
  description = "Datadog standard integration policy name"
  value       = "${element(concat(aws_iam_policy.datadog.*.name, list("")), 0)}"
}

output "role_arn" {
  description = "Datadog integration role ARN"
  value       = "${element(concat(aws_iam_role.datadog.*.arn, list("")), 0)}"
}

output "role_name" {
  description = "Datadog integration role name"
  value       = "${element(concat(aws_iam_role.datadog.*.name, list("")), 0)}"
}
