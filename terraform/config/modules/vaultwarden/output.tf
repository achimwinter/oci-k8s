output "vaultwarden_db_password" {
  value = random_password.vaultwarden_db_password.result
  sensitive = true
}