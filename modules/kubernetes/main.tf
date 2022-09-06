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
  subnet_pods = var.subnet_pods
  
  version = var.kubernetes_version
}

resource "oci_containerengine_cluster" "kubernetes" {
  compartment_id = local.compartment.id
  vcn_id = local.subnet_pods.vcn_id
  
  name = local.compartment.name
  kubernetes_version = local.version
  
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  
  options {
    kubernetes_network_config {
      pods_cidr = local.subnet_pods.cidr_block
      services_cidr = "10.96.0.0/16"
    }
  }
}
