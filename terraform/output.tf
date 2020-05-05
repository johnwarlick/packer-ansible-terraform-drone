output "vnet_id" {
  value = module.azure_network.vnet_id
}

output "vnet_address_space" {
  value = module.azure_network.vnet_address_space
}
output "vnet_location" {
  value = module.azure_network.vnet_location
}

output "vnet_subnets" {
  value = module.azure_network.vnet_subnets 
}

output "public_ips" {
  value = [azurerm_linux_virtual_machine.vms.*.public_ip_address]
}
