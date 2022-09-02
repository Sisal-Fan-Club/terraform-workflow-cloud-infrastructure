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
  
  profile = oci_core_network_security_group.profile
}

resource "oci_core_network_security_group" "profile" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = local.name
  
  freeform_tags = merge({}, local.vcn.freeform_tags)
}

resource "oci_core_network_security_group_security_rule" "default_ingress" {
  network_security_group_id = local.profile.id
  
  description = "Allow all traffic in same Security Profile"
  
  direction = "INGRESS"
  protocol = "all"
  source_type = "NETWORK_SECURITY_GROUP"
  source = local.profile.id
}

resource "oci_core_network_security_group_security_rule" "default_egress" {
  network_security_group_id = local.profile.id
  
  description = "Allow all traffic in same Security Profile"
  
  direction = "EGRESS"
  protocol = "all"
  destination_type = "NETWORK_SECURITY_GROUP"
  destination = local.profile.id
}

