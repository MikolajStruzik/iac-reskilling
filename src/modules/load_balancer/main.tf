# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
    name = "${var.lb_name}-pip"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name = var.lb_name
  location = var.location
  resource_group_name = var.resource_group_name
  sku = "Standard"
  frontend_ip_configuration {
    name = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_backend" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "backend-pool"
}

# Health Probe
resource "azurerm_lb_probe" "http_probe" {
    name = "http-probe"
    loadbalancer_id = azurerm_lb.lb.id
    protocol = "Http"
    port = 80
    request_path = "/"
    interval_in_seconds = 5
    number_of_probes = 2
}

# Load Balancing Rule
resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

# Associate each NIC to the LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  #for_each                  = toset(var.nic_ids)
  network_interface_id      = each.value
  for_each = { for idx, nic in var.nic_ids : "nic-${idx}" => nic }
  ip_configuration_name     = "interanal" # nazwa z VM modułu web_server
  backend_address_pool_id   = azurerm_lb_backend_address_pool.lb_backend.id
}