# Terraform global configuration
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 4"
    }
  }
}

module "governance" {
  source = "./modules/governance"
  providers = {
    oci = oci.home
  }
  
  parent_compartment = var.oci_tenancy_id
  name = "sisalfunclub-test"
  description = "Sisal Fun Club - Test Enviroment"
  
  environment = "test"
  app_code = "nsfc"
  factory = "Digital"
}
