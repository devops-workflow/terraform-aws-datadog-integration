variable "datadog_aws_account" {
  description = "The ID of Datadog's AWS account"
  default     = "464622532012"
}

variable "datadog_external_id" {
  description = "The external ID datadog gives you for the cross-account role"
  type        = "string"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating anything"
  default     = true
}

variable "enable_cloudtrail" {
  description = "Setup Datadog Cloudtrail integration"
  default     = false
}

variable "enable_autoscaling" {
  description = "Allow Datadog to trigger autoscaling policies"
  default     = false
}

variable "autoscaling_policy_name" {
  description = "Datadog autoscaling integration policy name"
  default     = "DatadogAWSIntegrationAutoscaling"
}

variable "aws_cloudtrail_bucket_arn" {
  description = "Cloudtrail S3 logs bucket ARN"
}

variable "cloudtrail_policy_name" {
  description = "Datadog Cloudtrail integration policy name"
  default     = "DatadogAWSIntegrationCloudtrailLogBucket"
}

variable "policy_name" {
  description = "The name for the IAM policy created to give Datadog permissions"
  default     = "DatadogAWSIntegrationPolicy"
}

variable "role_name" {
  description = "The name for the cross-account role Datadog will use to access your account"
  default     = "DatadogAWSIntegrationRole"
}
