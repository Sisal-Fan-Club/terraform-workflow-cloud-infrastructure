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
  compartment = var.compartment
  subnets = var.subnets
  
  vcn = oci_core_vcn.vcn
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment.id
  
  display_name = local.compartment.description
  
  cidr_blocks = values(local.subnets)
}

module "subnet" {
  for_each = local.subnets
  
  source = "./modules/subnet"
  providers = {
    oci = oci
  }
  
  vcn = local.vcn
  name = each.key
  cidr = each.value
}
