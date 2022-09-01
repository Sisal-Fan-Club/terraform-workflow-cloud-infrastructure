# Terraform global configuration
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 4"
    }
  }
}

locals {
  vcn = var.vcn
  cidr = var.cidr
  
  subnet = oci_core_subnet.subnet
}

resource "oci_core_subnet" "subnet" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  cidr_block = local.cidr
}
