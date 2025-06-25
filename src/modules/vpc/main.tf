# Virtual Network
resource "azurerm_virtual_network" "this" {
  name = var.vnet_name
  resource_group_name = var.resource_group_name
  location = var.location
  address_space = var.address_space
}

# Public subnets
resource "azurerm_subnet" "public" {
  for_each          = { for sn in var.public_subnets : sn.name => sn }
  name              = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [each.value.cidr]
}

# Private subnets
resource "azurerm_subnet" "private" {
  for_each            = { for sn in var.private_subnets : sn.name => sn }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name= azurerm_virtual_network.this.name
  address_prefixes    = [each.value.cidr]
}

# (optional) Public IP for NAT Gateway
resource "azurerm_public_ip" "nat" {
    count = var.enable_nat_gateway ? 1 : 0
    name = "${var.vnet_name}-nat-pip"
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "this" {
  count                = var.enable_nat_gateway ? 1 : 0
  name                 = "${var.vnet_name}-nat"
  resource_group_name  = var.resource_group_name
  location             = var.location
  sku_name             = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count           = var.enable_nat_gateway ? 1 : 0
  nat_gateway_id = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

# Przypięcie NAT do prywatnych subnets
resource "azurerm_subnet_nat_gateway_association" "private" {
  for_each       = var.enable_nat_gateway ? azurerm_subnet.private : {}
  subnet_id      = each.value.id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}