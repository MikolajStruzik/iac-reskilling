output "vnet_id" {
    description = "ID Virtual Network"
    value = azurerm_virtual_network.this.id 
}
output "public_subnet_ids" { 
    description = "List of Ids of public subnets"
    value = [for s in azurerm_subnet.public : s.id] 
}

output "private_subnet_ids" { 
    description = "List of Ids of private subnets"
    value = [for s in azurerm_subnet.private : s.id] 
}