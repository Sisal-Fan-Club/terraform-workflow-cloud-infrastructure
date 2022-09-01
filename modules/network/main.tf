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

resource "oci_core_internet_gateway" "igw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
}

resource "oci_core_nat_gateway" "ngw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
}

locals {
  route_table_commons = {
    compartment_id = local.vcn.compartment_id
    vcn_id = local.vcn.id
  }
}

resource "oci_core_route_table" "public" {
  compartment_id = local.route_table_commons.compartment_id
  vcn_id = local.route_table_commons.vcn_id
  
  route_rules {
    description = "Default route via Internet Gateway (NAT 1:N)"
    network_entity_id = oci_core_internet_gateway.igw.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = local.route_table_commons.compartment_id
  vcn_id = local.route_table_commons.vcn_id
  
  route_rules {
    description = "Default route via NAT Gateway (NAT N:1)"
    network_entity_id = oci_core_nat_gateway.ngw.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
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
