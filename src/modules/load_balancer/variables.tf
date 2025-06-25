variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "lb_name" {
  type = string
  description = "Name of the Load Balancer"
}

variable "nic_ids" {
  type = list(string)
  description = "List of NIC IDs to register in backend pool"
}