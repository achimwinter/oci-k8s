resource "oci_dns_zone" "achim_winter_zone" {
  compartment_id = var.compartment_id
  name           = var.achim_winter_domain_name
  zone_type      = "PRIMARY"
}