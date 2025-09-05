output "postgresql_cnpg_primary_service" {
  description = "CloudNativePG primary service endpoint"
  value       = "postgresql-cnpg-rw.postgresql.svc.cluster.local"
}

output "postgresql_cnpg_readonly_service" {
  description = "CloudNativePG readonly service endpoint"  
  value       = "postgresql-cnpg-ro.postgresql.svc.cluster.local"
}