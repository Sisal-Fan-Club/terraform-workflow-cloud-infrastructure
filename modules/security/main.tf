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
}

resource "oci_core_security_list" "disabled" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = "Disabled Security Lists"
  
  ingress_security_rules {
    description = "Allow all traffic TO the subnet"
    protocol = "all"
    source = "0.0.0.0/0"
  }
  
  egress_security_rules {
    description = "Allow all traffic FROM the subnet"
    protocol = "all"
    destination  = "0.0.0.0/0"
  }
}

locals {
  nsg_commons = {
    compartment_id = local.vcn.compartment_id
    vcn_id = local.vcn.id
  }
}
resource "oci_core_network_security_group" "mgmt" {
  compartment_id = local.nsg_commons.compartment_id
  vcn_id = local.nsg_commons.vcn_id
  
  display_name = "Management Security Profile"
}

resource "oci_core_network_security_group" "app" {
  compartment_id = local.nsg_commons.compartment_id
  vcn_id = local.nsg_commons.vcn_id
  
  display_name = "Application Security Profile"
}

resource "oci_core_network_security_group" "dmz" {
  compartment_id = local.nsg_commons.compartment_id
  vcn_id = local.nsg_commons.vcn_id
  
  display_name = "DMZ Security Profile"
}
