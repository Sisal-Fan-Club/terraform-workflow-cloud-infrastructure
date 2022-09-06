output "vcn" {
  depends_on = [
    module.subnet
  ]
    
  value = merge({
    subnets = { for subnet_name, subnet_module in module.subnet: subnet_name => subnet_module.subnet }
  }, local.vcn)
}
