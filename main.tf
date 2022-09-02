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
  source = "./modules/network"
  providers = {
    oci = oci
  }
  
  compartment = module.governance.compartment
  subnets = {
    app = {
      cidr = "192.168.0.0/24"
      exposed = false
    }
    
    dmz = {
      cidr = "192.168.100.0/24"
      exposed = true
    }
  }
}

module "network" {
  source = "./modules/security"
  providers = {
    oci = oci
  }
  
  vcn = module.network.vcn
}
