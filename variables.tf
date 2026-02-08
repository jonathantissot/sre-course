variable "vpc" {
  type = object({
    cidr_block = string
    public_subnets = list(string)
    private_subnets = list(string)
  })
}

variable "environment" {
  type = string
}