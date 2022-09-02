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
  cidr = var.cidr
  name = var.name
  exposed = var.exposed
  other_routes = var.routes
  default_gateway_id = var.default_gateway_id
  
  subnet = oci_core_subnet.subnet
  routes = oci_core_route_table.routes
}


resource "oci_core_route_table" "routes" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = local.name
  
  dynamic "route_rules" {
    for_each = local.other_routes
    
    content {
      description = route_rules.value.description
      network_entity_id = route_rules.value.network_entity_id
      destination = route_rules.value.destination
      destination_type = route_rules.value.destination_type
    }
  }
  
  route_rules {
    description = "Default route"
    network_entity_id = local.default_gateway_id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
  
  freeform_tags = merge({}, local.vcn.freeform_tags)
}

resource "oci_core_subnet" "subnet" {
  compartment_id = local.vcn.compartment_id
  vcn_id = local.vcn.id
  
  display_name = local.name
  cidr_block = local.cidr
  
  prohibit_internet_ingress = !local.exposed
  
  route_table_id = oci_core_route_table.routes.id
  
  freeform_tags = merge({}, local.vcn.freeform_tags)
}

resource "oci_core_route_table_attachment" "routing" {
  subnet_id = local.subnet.id
  route_table_id = local.routes.id
}
