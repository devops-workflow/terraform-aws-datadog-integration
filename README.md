[![CircleCI](https://circleci.com/gh/devops-workflow/terraform-aws-datadog-integration.svg?style=svg)](https://circleci.com/gh/devops-workflow/terraform-aws-datadog-integration)

# terraform-aws-datadog-integration

Terraform module for configuring AWS for Datadog integration

This will setup the standard configuration, but also has options to setup Autoscaling, Cloudtrail, and logging

Options are also provided for controlling IAM policy and role names

For Logging, only the permissions are currently setup. Not the required Lambda

#### Example: standard use

```hcl
module "datadog" {
  source              = "devops-workflow/datadog-integration/aws"
  datadog_external_id = "12345"
}
```

#### Example: with Autoscaling enabled

```hcl
module "datadog" {
  source              = "devops-workflow/datadog-integration/aws"
  datadog_external_id = "12345"
  enable_autoscaling  = true
}
```

#### Example: with Cloudtrail enabled

```hcl
module "datadog" {
  source                    = "devops-workflow/datadog-integration/aws"
  datadog_external_id       = "12345"
  enable_cloudtrail         = true
  aws_cloudtrail_bucket_arn = "arn:aws:s3:::your-s3-cloudtrail-bucket-name"
}
```
