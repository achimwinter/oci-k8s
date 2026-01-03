output "traefik_namespace" {
  description = "Namespace where Traefik is deployed"
  value       = helm_release.traefik.namespace
}

output "traefik_service_name" {
  description = "Name of the Traefik service"
  value       = helm_release.traefik.name
}

output "traefik_chart_version" {
  description = "Version of the Traefik Helm chart"
  value       = helm_release.traefik.version
}

output "security_group_id" {
  description = "OCI Network Security Group ID for Traefik LoadBalancer"
  value       = oci_core_network_security_group.traefik_lb.id
}

output "security_group_name" {
  description = "OCI Network Security Group name for Traefik LoadBalancer"
  value       = oci_core_network_security_group.traefik_lb.display_name
}
