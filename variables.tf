variable "vpc" {
  type = object({
    cidr_block = string
    public_subnets = number
    private_subnets = number
  })
}

variable "environment" {
  type = string
}