output "postgresql_service" {
  description = "The service name of the PostgreSQL deployment."
  value       = helm_release.postgresql.metadata
}
