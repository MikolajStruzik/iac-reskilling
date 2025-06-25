output "vnet_id" {
  description = "ID utworzonego VNet"
  value       = module.vnet.vnet_id
}

output "public_subnet_ids" {
  description = "ID publicznych podsieci"
  value       = module.vnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "ID prywatnych podsieci"
  value       = module.vnet.private_subnet_ids
}

output "nic_id" {
  value = module.web_server.nic_ids[0]
}