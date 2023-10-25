data "oci_secrets_secretbundle" "jmusic_owner" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya74zkvauz42iqs6hhusafw7476m5f65p2eqy6ubjof3oq"
}

data "oci_secrets_secretbundle" "jmusic_token" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yamtrk2pftbkka3rhuintu7kjq72ylwtacy34h4y2zsx6q"
}
