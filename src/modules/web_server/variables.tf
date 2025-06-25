variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "subnet_id" {
  type = string
}

variable "storage_account_name" {
  type = string
  description = "Name of Storage Account with index.html file"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the storage container"
}

# variable "container_name" {
#     type = string
#     description = "Blob container from where I download index.html"
# }

variable "vm_name" {
  type = string
  default = "iac-web-vm"
}

variable "admin_username" {
 type = string 
 default = "azureuser"
}

variable "admin_password" {
 description = "admin password"
 type = string
 sensitive = true 
}

