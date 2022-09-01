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

variable "routes_table" {
}

variable "default_gateway" {}
