
resource "oci_core_default_security_list" "disabling" {
  manage_default_resource_id = local.vcn.default_security_list_id
  
  display_name = "Disabled Security Lists"
  
  ingress_security_rules {
    description = "Allow all traffic TO the subnet"
    protocol = "all"
    source = "0.0.0.0/0"
  }
  
  egress_security_rules {
    description = "Allow all traffic FROM the subnet"
    protocol = "all"
    destination  = "0.0.0.0/0"
  }
}
