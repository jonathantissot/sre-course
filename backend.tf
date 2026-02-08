terraform {
  backend "s3" {
    profile = "fet-aws"
    bucket = "fet-sre-course"
    region = "us-east-1"
    use_lockfile = true
  }
}