# Only secret metadata (e.g. the friendly name used to look the secret up in
# OCI Vault) is read here - secret content is fetched at runtime by the
# External Secrets Operator via the ClusterSecretStore, never through Terraform.
data "oci_vault_secret" "nextcloud_db_username" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya26jo756iwhar3auxvxmyv3gmfowiqecfka42moe4rqwa"
}

data "oci_vault_secret" "nextcloud_db_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yalpopdhxriq5fvrscjah5yxx5phi5xih5rbgruhvwbbfa"
}

data "oci_vault_secret" "nextcloud_username" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yae3gibs2w6qaw6knxhoqnav33iqxkqda5rb6g7owyxtbq"
}

data "oci_vault_secret" "nextcloud_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yaeqchbaslwy24v5xplnrrxjsrqzcm7mot3giwvfbt3tfa"
}

data "oci_vault_secret" "vaultwarden_admin_token" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya4m6xti6jgq3s665dp6ssnsgdp4vfiecasao6i3rnzc3a"
}

data "oci_vault_secret" "vaultwarden_db_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya42udrj6mxaorn4swkzihzceerklplqhkdd77mok3uljq"
}

