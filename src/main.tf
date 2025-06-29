terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
  subscription_id = "5b1f44b3-6eaf-4447-b261-d08a610a5eaa"
}

resource "azurerm_resource_group" "main" {
  name = "iac-reskilling-rg"
  location = "westeurope"
}

# Using of vnet module
module "vnet" {
  source              = "./modules/vpc"
  resource_group_name = "iac-reskilling-rg"
  location            = "westeurope"
  vnet_name           = "iac-vnet"
  address_space       = ["10.1.0.0/16"]
  public_subnets = [
    { name = "public-1"
      cidr = "10.1.1.0/24" },
    { name = "public-2"
      cidr = "10.1.2.0/24" },
  ]
  private_subnets = [
    { name = "private-1"
     cidr = "10.1.3.0/24" },
    { name = "private-2"
     cidr = "10.1.4.0/24" },
  ]
  enable_nat_gateway = false
}

# Azure Storage Account
resource "azurerm_storage_account" "web" {
  name                     = "iacreskillingweb01"    # musi być unikalne globalnie
  resource_group_name      = "iac-reskilling-rg"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# resource "azurerm_storage_account_blob_properties" "web" {
#   storage_account_id       = azurerm_storage_account.web.id
#   allow_blob_public_access = true
# }

resource "azurerm_storage_container" "web" {
  name                  = "web-content"
  storage_account_name  = azurerm_storage_account.web.name
  container_access_type = "blob"   # publiczny dostęp do blobów (nie całego kontenera)
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = azurerm_storage_container.web.name
  type                   = "Block"
  source                 = "${path.module}/files/index.html"
  #content_type           = "text/html"
}

# Azure VM
module "web_server" {
  source = "./modules/web_server"
  resource_group_name = "iac-reskilling-rg"
  location = "westeurope"
  subnet_id = module.vnet.public_subnet_ids[0] # use 1st public subnet from list
  vm_name = "iac-web"
  storage_account_name = azurerm_storage_account.web.name
  #container_name = azurerm_storage_container.web.name
  storage_container_name = azurerm_storage_container.web.name
  admin_username = "azureuser"
  admin_password = var.admin_password
}

module "load_balancer" {
  source = "./modules/load_balancer"
  resource_group_name = "iac-reskilling-rg"
  location = "westeurope"
  lb_name = "iac-loadbalancer"
  nic_ids = module.web_server.nic_ids
}

# Database module: only creates table and storage
module "database" {
  source               = "./modules/database"
  storage_account_name = azurerm_storage_account.web.name
  table_name           = "iacresources"
}

# Resource scanner
module "resource_scanner" {
   source      = "./modules/resource_scanner"

   name_prefix = "iac"
   resource_group_name                = azurerm_resource_group.main.name
   location                           = azurerm_resource_group.main.location

  # brakująca zmienna — connection string do tego samego Storage Account
   storage_account_connection_string  = azurerm_storage_account.web.primary_connection_string
   storage_account_name               = azurerm_storage_account.web.name
   storage_account_key                = azurerm_storage_account.web.primary_access_key
   
   table_name                         = module.database.table_name
   blob_container                     = azurerm_storage_container.web.name

   tag_owner       = "mikolaj.struzik@atos.net"
   tag_project     = "IaC Reskilling"
   subscription_id = data.azurerm_client_config.current.subscription_id
 }