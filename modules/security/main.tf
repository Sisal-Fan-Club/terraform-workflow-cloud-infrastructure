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
