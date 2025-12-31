module "rg" {
  source      = "../modules/azurerm_resource_group"
  rg_name     = "Global"
  rg_location = "centralindia"
}

# attached frontend pip to frontend VM
module "pip_frontend" {
  depends_on  = [module.rg]
  source      = "../modules/azurerm_pip"
  rg_location = "centralindia"
  pip_name    = "mypip_frontend"
  rg_name     = "Global"
  vm_frontend_ip_name = "mypip_frontend"
}

module "vnet" {
  depends_on    = [module.rg]
  source        = "../modules/azurerm_virtual_network"
  vnet_name     = "myvnet"
  rg_name       = "Global"
  rg_location   = "centralindia"
  address_space = ["10.1.0.0/16"]
}

# Issue: backend and frontend subnet do bar repeat ho rha hai 

module "frontend_subnet" {
  depends_on       = [module.vnet]
  source           = "../modules/azurerm_subnet"
  subnet_name      = "frontend_subnet"
  rg_name          = "Global"
  vnet_name        = "myvnet"
  address_prefixes = ["10.0.0.0/20"]
}

module "back_subnet" {
  depends_on       = [module.vnet]
  source           = "../modules/azurerm_subnet"
  subnet_name      = "backend_subnet"
  rg_name          = "Global"
  vnet_name        = "myvnet"
  address_prefixes = ["10.0.0.0/20"]
}

module "keyvault" {
  depends_on = [module.rg]
  source     = "../modules/azurerm_key_vault"
  keyvault   = "mykeyvault01"
  location   = "Centralindia"
  rg_name    = "Global"
}

module "nic" {
  depends_on          = [module.rg, module.pip_frontend, module.frontend_subnet]
  source               = "../modules/azurerm_nic"
  nic_name             = "nic-frontend"
  location             = "centralindia"
  rg_name              = "Global"
  vm_frontend_ip_name  = "mypip_frontend"
  frontend_subnet_name = "frontend_subnet"
  virtual_network_name = "myvnet"
  subnet_name          = "frontend_subnet"
 
}


module "linux_vm_frontend" {
  depends_on    = [module.nic, module.keyvault, module.rg, module.pip_frontend, module.frontend_subnet, module.vnet, module.frontend_subnet]
  source        = "../modules/azurerm_linux_vm"
  vm_name       = "linux-vm-frontend"
  rg_name       = "Global"
  rg_location   = "centralindia"
  vm_size       = "Standard_B1s"
  key_vault_name        = "mykeyvault01"
  username_secret_name  = "remote_machine"
  password_secret_name  = "P@ssw0rd1234"
  nic_id =  module.nic.nic_id
}

module "sql_database" {
  depends_on        = [module.rg, module.mssql_server]
  source            = "../modules/azurerm_mssql_database"
  sql_database_name = "mysqldatabase01"
  sql_server_name   = "mysqlserver01"
  rg_name           = "Global"
} 

module "mssql_server" {
  depends_on                  = [module.rg]
  source                      = "../modules/azurerm_mssql_server"
  sql_server_name             = "mysqlserver01"
  rg_name                     = "Global"
  rg_location                 = "centralindia"
  administrator_login         = "sqladminuser"
  administrator_login_password= "Str0ngP@ssword!"
}
