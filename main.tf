# Data, Resource, Variable, Output, Locals, Provider

# GET Request
data "http" "dlocal_api" {
  url = "https://api.dlocal.com/_healthcheck"
}

# Output
output "dlocal_response" {
  value = data.http.dlocal_api.response_body
}

data "aws_s3_bucket" "fet_aws_tfstates" {
  bucket = "fet-sre-course"
}

output "s3_bucket_arn" {
  value = data.aws_s3_bucket.fet_aws_tfstates.arn
}

resource "random_password" "database" {
  length           = 16
  special          = false
}

output "database_password" {
  value = random_password.database.result
  sensitive = true
}