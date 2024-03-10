data "oci_secrets_secretbundle" "admin_token" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya4m6xti6jgq3s665dp6ssnsgdp4vfiecasao6i3rnzc3a"
}

data "oci_secrets_secretbundle" "vaultwarden_db_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya42udrj6mxaorn4swkzihzceerklplqhkdd77mok3uljq"
}
