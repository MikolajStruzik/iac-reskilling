# Public SSH (temporary, for testing purposes)
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "azurerm_linux_virtual_machine" "web" {
  name = var.vm_name
  resource_group_name = var.resource_group_name
  location = var.location
  size = "Standard_B1s" # Free Tier
  admin_username = var.admin_username
  admin_password = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  disable_password_authentication = false

  # admin_ssh_key {
  #   username = "azureuser"
  #   public_key = tls_private_key.example.public_key_openssh
  # }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  custom_data = base64encode(templatefile(
    "${path.root}/files/cloud-init.tpl",{
        storage_account_name = var.storage_account_name
        storage_container_name = var.storage_container_name
    }
  ))
}

# NIC
resource "azurerm_network_interface" "web_nic" {
  name = "${var.vm_name}-nic"
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "interanal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.web.id
  }
}

# Security Group with port 80
resource "azurerm_network_security_group" "web_nsg" {
  name = "${var.vm_name}-nsg"
  location = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name = "Allow_HTTP"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "web_nsg_assoc" {
    network_interface_id = azurerm_network_interface.web_nic.id
    network_security_group_id = azurerm_network_security_group.web_nsg.id
}

resource "azurerm_public_ip" "web" {
  name = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
}