resource "oci_identity_dynamic_group" "external_secrets" {
  compartment_id = var.tenancy_ocid
  name           = "external-secrets-oke-nodes"
  description    = "OKE worker node instances allowed to authenticate to OCI Vault via instance principal for External Secrets Operator"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_id}'}"
}

resource "oci_identity_policy" "external_secrets_vault_read" {
  compartment_id = var.tenancy_ocid
  name           = "external-secrets-vault-read"
  description    = "Allow OKE node instances to read OCI Vault secrets for External Secrets Operator"

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.external_secrets.name} to read secret-family in compartment id ${var.compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.external_secrets.name} to read vaults in compartment id ${var.compartment_id}",
  ]
}
