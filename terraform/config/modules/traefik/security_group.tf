data "oci_core_vcns" "k8s_vcn" {
  compartment_id = var.compartment_id

  display_name = "k8s-vcn"
}

resource "oci_core_network_security_group" "traefik_lb" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = data.oci_core_vcns.k8s_vcn.virtual_networks[0].id

  display_name = "traefik-ingress"
}

resource "oci_core_network_security_group_security_rule" "traefik_http" {
  network_security_group_id = oci_core_network_security_group.traefik_lb.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  #Optional
  description = "traefik_http_80"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "traefik_https" {
  network_security_group_id = oci_core_network_security_group.traefik_lb.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  #Optional
  description = "traefik_https_443"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}
