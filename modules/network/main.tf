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
  
  cidr_blocks = [ for name, subnet in local.subnets: subnet.cidr ]
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
}

resource "oci_core_nat_gateway" "ngw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
}

module "subnet" {
  for_each = local.subnets
  
  source = "./modules/subnet"
  providers = {
    oci = oci
  }
  
  vcn = local.vcn
  
  name = each.key
  cidr = each.value.cidr
  exposed = each.value.exposed
  
  default_gateway_id = each.value.exposed ? oci_core_internet_gateway.igw.id : oci_core_nat_gateway.ngw.id
}
