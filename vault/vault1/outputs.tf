output "vault_token" {
  value       = var.vault_root_token
  sensitive   = true
  description = "Root token for Vault"
}
