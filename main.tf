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
  app_name = "sisalfanclub"
  app_code = "nsfc"
  factory = "digital"
  environment = "test"
  
  description = "Sisal Fan Club"
}

module "governance" {
  source = "./modules/governance"
  providers = {
    oci = oci.home
  }
  
  parent_compartment = var.oci_tenancy_id
  name = format("%s-%s", local.app_name, local.environment)
  description = format("%s - Environment: %s", local.description, local.environment)
  
  environment = local.environment
  app_code = local.app_code
  factory = local.factory
}

module "observability" {
  source = "./modules/observability"
  providers = {
    oci = oci
  }
  
  compartment = module.governance.compartment
}

module "network" {
  source = "./modules/network"
  providers = {
    oci = oci
  }
  
  compartment = module.governance.compartment
  log_group = module.observability.log_group

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

module "security" {
  source = "./modules/security"
  providers = {
    oci = oci
  }
  
  vcn = module.network.vcn
}
