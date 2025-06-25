variable "name_prefix" {
  type = string
  description = "Prefix of resource names"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "storage_account_name" {
  description = "Storage Account with table and blob"
  type = string
}

variable "storage_account_key" {
  description = "Access key to Storage Account"
  type = string
  sensitive = true
}

variable "table_name" {
  type = string
}

variable "blob_container" {
  description = "Blob container for generating index.html"
  type = string
}

variable "tag_owner" {
  type = string
  default = "mikolaj.struzik@atos.net"
}

variable "tag_project" {
  type = string
  default = "IaC Reskilling"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}