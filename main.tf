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

module "network" {
  source = "./modules/governance"
  providers = {
    oci = oci
  }
  
  compartment = module.governance.compartment
  subnets = {
    app = "192.168.0.0/24"
    dmz = "192.168.100.0/24"
  }
}
