variable "vault_root_token" {
  description = "Root token for Vault"
  type        = string
  sensitive   = true
  default = "root" # Usa una variabile d'ambiente o tfvars per sovrascrivere
}

variable "vault_external_port" {
  description = "Port to expose Vault"
  type        = number
  default     = 8200
}

variable "vault_data_path" {
  description = "Path to persist Vault data"
  type        = string
  default     = "/tmp/vault-data"
}

variable "vault_host" {
  description = "Vault host"
  type        = string
  default     = "127.0.0.1"
}
