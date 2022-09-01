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
  root_compartment = var.root_compartment
  name = var.name
  description = var.description
  
  freeform_tags = {
    app-code = var.app_code
    factory = var.factory
    environment = var.environment
  } 
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = local.root_compartment
  
  name = local.name
  description = local.description
  enable_delete = true
  
  freeform_tags = merge({
    managed-by = "Terraform"
  }, local.freeform_tags)
}
