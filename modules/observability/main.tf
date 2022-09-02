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
  
  log_group = oci_logging_log_group.cloud-infrastructure
}

resource "oci_logging_log_group" "cloud-infrastructure" {
  compartment_id = local.compartment.id
  
  display_name = "cloud-infrastructure"
  description = "Logs from Cloud Infrastructure components"
}
