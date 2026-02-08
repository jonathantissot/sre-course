environment = "dev"

vpc = {
  cidr_block = "10.0.0.0/22"
  public_subnets = 2
  private_subnets = 2
  # newbits 2 -> 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24
  # newnum 0 -> 10.0.0.0/24
  # newnum 1 -> 10.0.1.0/24
  # Dev, QA, UAT, Staging, Sandbox, Mgmt, etc.
}