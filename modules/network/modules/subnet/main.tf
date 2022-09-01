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
  name = var.name
  exposed = var.exposed
  
  subnet = oci_core_subnet.subnet
}

resource "oci_core_subnet" "subnet" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = local.name
  cidr_block = local.cidr
  
  prohibit_internet_ingress = !local.exposed
}
