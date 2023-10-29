module "jmusicbot" {
  source = "./modules/jmusicbot"

  compartment_id = var.compartment_id
  vault_id       = var.vault_id
}

module "traefik" {
  source  = "./modules/traefik"

  compartment_id = var.compartment_id
}
