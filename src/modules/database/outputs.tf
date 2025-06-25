output "table_name" {
  description = "Name of the Azure Table Storage"
  value = azurerm_storage_table.resource_table.name
}

output "inserted_entity_id" {
  description = "ID of the inserted table entity"
  value       = azurerm_storage_table_entity.resource.id
}
