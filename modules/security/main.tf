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
  
  profiles = {
    mgmt = {
      name = "Management Security Profile"
    }
    
    app = {
      name = "Application Security Profile"
    }
    
    dmz = {
      name = "DMZ Security Profile"
    }
  }
  
  profiles = module.profile
}

module "profile" {
  for_each = local.profiles
  
  source = "./modules/profiles"
  providers = {
    oci = oci
  }
  
  vcn = local.vcn
  name = each.value.name
}
