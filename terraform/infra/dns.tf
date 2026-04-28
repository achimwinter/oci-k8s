resource "oci_dns_zone" "nexpass_zone" {
  compartment_id = var.compartment_id
  name           = var.nexpass_domain_name
  zone_type      = "PRIMARY"
}