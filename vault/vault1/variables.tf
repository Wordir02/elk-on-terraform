variable "vault_root_token" {
  description = "Root token for Vault"
  type        = string
  sensitive   = true
}

variable "vault_external_port" {
  description = "Port to expose Vault service"
  type        = number
  default     = 8200
}

variable "vault_data_path" {
  description = "Path to persist Vault data on the host"
  type        = string
  default     = "/tmp/vault-data"
}

variable "vault_host" {
  description = "Host where Vault will run"
  type        = string
  default     = "127.0.0.1"
}
