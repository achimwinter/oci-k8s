terraform {

  backend "s3" {
    bucket                      = "terraform-states"
    key                         = "infra/terraform.tfstate"
    endpoint                    = "https://frpnphd9w23e.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    region                      = "eu-frankfurt-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.37.0"
    }
  }
}

