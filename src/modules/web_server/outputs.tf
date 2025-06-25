output "vm_id" {
  description = "VM Web Id"
  value = azurerm_linux_virtual_machine.web.id
}

# output "public_key" {
#  description = "public key for ssh tests"
#  value = tls_private_key.example.public_key_openssh 
# }

output "nic_ids" {
  description = "ID kart sieciowych VM"
  value = [azurerm_network_interface.web_nic.id]
}