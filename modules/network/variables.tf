variable "compartment" {
}

variable "subnets" {
  type = map(object({
    cidr = string
    exposed = bool
  }))
}
