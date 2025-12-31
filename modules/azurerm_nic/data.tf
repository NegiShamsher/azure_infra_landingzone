data "azurerm_public_ip" "pip" {
  name                = var.vm_frontend_ip_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "frontend_subnet" {
  name                 = var.frontend_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.rg_name
}



output "nic_id" {
  value = azurerm_network_interface.nic.id
}