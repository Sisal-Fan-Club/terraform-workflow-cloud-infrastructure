#
Terraform global configuration
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 4"
    }
  }
}

locals {
  cluster = var.cluster
  
  ads = data.oci_identity_availability_domains.availability_domains.availability_domains
}

resource "oci_containerengine_node_pool" "nodepool" {
  compartment_id = local.cluster.compartment_id
  cluster_id = local.cluster.id
  
  name = local.cluster.name
  kubernetes_version = local.cluster.kubernetes_version
  size = 3
  
  node_shape = "VM.Standard.E4.Flex"
  node_shape_config {
    ocpus = 1
    memory_in_gbs = 1
  }
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = local.cluster.compartment_id 
}
