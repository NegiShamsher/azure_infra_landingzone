variable "vm_name" {}
variable "rg_name" {}
variable "rg_location" {}
variable "vm_size" {}

variable "username_secret_name" {}
variable "password_secret_name" {}
variable "key_vault_name" {}
variable "nic_id" {
  type = string
}