variable "name_prefix" {
  type        = string
  description = "Prefix for all names"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "storage_account_connection_string" {
  type        = string
  description = "Connection string to Storage Account"
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_key" {
  type      = string
  sensitive = true
}

variable "table_name" {
  type = string
}

variable "blob_container" {
  type = string
}

variable "tag_owner" {
  type    = string
  default = "mikolaj.struzik@atos.net"
}

variable "tag_project" {
  type    = string
  default = "IaC Reskilling"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}
