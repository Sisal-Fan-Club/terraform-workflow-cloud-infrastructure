variable "compartment" {
}

variable "log_group" {}

variable "subnets" {
  type = map(object({
    cidr = string
    exposed = bool
  }))
}
