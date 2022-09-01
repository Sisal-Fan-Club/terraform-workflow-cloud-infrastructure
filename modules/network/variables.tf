locals {
  compartment = var.compartment
  subnets = var.subnets
  
  vcn = oci_core_vcn.vcn
}

variable "compartment" {
  type = object
}

variable "subnets" {
  type = map(string)
}
