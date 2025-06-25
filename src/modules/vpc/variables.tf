variable "resource_group_name" { type = string }
variable "location"            { 
    type = string 
    default = "westeurope" 
}

variable "vnet_name"           { type = string }

variable "address_space"       { type = list(string) }

variable "public_subnets" {
  type = list(object({ name = string, cidr = string }))
}

variable "private_subnets" {
  type = list(object({ name = string, cidr = string }))
}
variable "enable_nat_gateway"  { 
    type = bool
    default = false 
 }
