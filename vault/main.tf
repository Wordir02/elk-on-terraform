

provider "vault" {
  address = module.vault.vault_address
  token   = var.vault_root_token
}

module "vault" {
  source = "./vault1"
  vault_root_token = var.vault_root_token
  vault_external_port = var.vault_external_port
  vault_data_path = var.vault_data_path
  vault_host = var.vault_host
}