variable "vcn" {
}

variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "exposed" {
  type = bool
  default = false
}

variable "default_gateway_id" {
  type = string
}

variable "routes" {}
