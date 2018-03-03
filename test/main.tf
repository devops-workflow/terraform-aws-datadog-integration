module "disabled" {
  source              = "../"
  datadog_external_id = "12345"
  enabled             = false
}

/*
module "datadog" {
  source              = "../"
  datadog_external_id = "12345"
}
*/

module "complete" {
  source                    = "../"
  datadog_external_id       = "12345"
  enable_autoscaling        = true
  enable_cloudtrail         = true
  enable_logging            = true
  aws_cloudtrail_bucket_arn = "xxx"
}
