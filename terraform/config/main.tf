module "jmusicbot" {
  source = "./modules/jmusicbot"

  compartment_id = var.compartment_id
  vault_id       = var.vault_id
}

# module "longhorn" {
#   source = "./modules/longhorn"

#   compartment_id = var.compartment_id
#   vault_id       = var.vault_id
# }

module "traefik" {
  source  = "./modules/traefik"

  compartment_id = var.compartment_id
}

# module "certmanager" {
#   source = "./modules/cert-manager"
# }

# module "externaldns" {
#   source = "./modules/external-dns"

#   compartment_id = var.compartment_id
# }
