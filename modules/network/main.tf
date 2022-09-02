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
  log_group = var.log_group
  
  subnets = var.subnets
  
  vcn = oci_core_vcn.vcn
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment.id
  
  display_name = local.compartment.description
  
  cidr_blocks = [ for name, subnet in local.subnets: subnet.cidr ]
    
  freeform_tags = merge({}, local.compartment.freeform_tags)
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = "NAT 1:1"
  
  freeform_tags = merge({}, local.vcn.freeform_tags)
}

resource "oci_core_nat_gateway" "ngw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = "NAT N:1"
  
  freeform_tags = merge({}, local.vcn.freeform_tags)
}

data "oci_core_services" "oci_services" {
  filter {
    name = "name"
    values = ["^All .* Services In Oracle Services Network"]
    regex = true
  }
}

resource "oci_core_service_gateway" "sgw" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id

  display_name = "OCI Backbone Gateway"

  dynamic "services" {
    for_each = { for service in data.oci_core_services.oci_services.services: 
      service.id => service
    }

    content {
      service_id = services.value.id
    }
  }
}

locals {
  route_oci_services = {
    for service in data.oci_core_services.oci_services.services:
      service.id => {
        description = ""
        destination = service.cidr_block
        destination_type = "SERVICE_CIDR_BLOCK"
        gateway = oci_core_service_gateway.sgw.id
      }
  }
}
  
module "subnet" {
  for_each = local.subnets
  
  source = "./modules/subnet"
  providers = {
    oci = oci
  }
  
  vcn = local.vcn
  
  name = each.key
  cidr = each.value.cidr
  exposed = each.value.exposed
  
  routes = merge({
  }, local.route_oci_services)
  default_gateway_id = each.value.exposed ? oci_core_internet_gateway.igw.id : oci_core_nat_gateway.ngw.id
}
  
resource "oci_logging_log" "network_flows" {
  for_each = { for subnet_name, subnet in module.subnet: subnet_name => subnet.subnet }
    
  log_group_id = local.log_group.id
  log_type = "SERVICE"
  
  display_name = "subnet_${each.value.display_name}"
  retention_duration = 30
  
  configuration {
    compartment_id = local.vcn.compartment_id
    
    source {
      source_type = "OCISERVICE"
      category = "all"
      service = "flowlogs"
      resource = each.value.id
    }
  }
    
  freeform_tags = merge({}, local.vcn.freeform_tags)
}
