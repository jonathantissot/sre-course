terraform {
  backend "s3" {
    bucket = "fet-sre-course"
    key    = "sre-course/production.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}