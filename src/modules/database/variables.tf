variable "table_name" {
  description = "Name of the Azure Table Storage"
  type        = string
}
variable "storage_account_name" {
  description = "Name of the existing Azure Storage Account"
  type        = string
}

variable "resource_id" {
  description = "Resource ID used as the row's primary key"
  type        = string
}