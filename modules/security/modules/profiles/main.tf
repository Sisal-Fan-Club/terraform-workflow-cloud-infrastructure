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
  name = var.name
}

resource "oci_core_network_security_group" "profile" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = local.name
}
