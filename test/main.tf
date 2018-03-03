module "disabled" {
  source                    = "../"
  aws_cloudtrail_bucket_arn = ""
  datadog_external_id       = "12345"
  enabled                   = false
}

module "datadog" {
  source                    = "../"
  aws_cloudtrail_bucket_arn = ""
  datadog_external_id       = "12345"
}
