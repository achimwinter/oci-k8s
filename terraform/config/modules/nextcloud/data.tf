data "oci_secrets_secretbundle" "nextcloud_db_username" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4ya26jo756iwhar3auxvxmyv3gmfowiqecfka42moe4rqwa"
}

data "oci_secrets_secretbundle" "nextcloud_db_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yalpopdhxriq5fvrscjah5yxx5phi5xih5rbgruhvwbbfa"
}

data "oci_secrets_secretbundle" "nextcloud_username" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yae3gibs2w6qaw6knxhoqnav33iqxkqda5rb6g7owyxtbq"
}

data "oci_secrets_secretbundle" "nextcloud_password" {
  secret_id = "ocid1.vaultsecret.oc1.eu-frankfurt-1.amaaaaaaugy2z4yaeqchbaslwy24v5xplnrrxjsrqzcm7mot3giwvfbt3tfa"
}
