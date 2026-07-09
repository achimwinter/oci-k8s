variable "compartment_id" {
  description = "The compartment containing the OKE node pool and the OCI Vault"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID, used to create the dynamic group and IAM policy"
  type        = string
}

variable "vault_id" {
  description = "OCI Vault OCID"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string

  default = "eu-frankfurt-1"
}
