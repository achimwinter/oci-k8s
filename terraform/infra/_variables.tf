variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "region" {
  description = "OCI region"
  type        = string

  default     = "eu-frankfurt-1"
}

variable "ssh_public_key" {
  description = "SSH Public Key used to access all instances"
  type        = string

  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICceiX6QPzSsbGfiQNuwA+9rTYZOfww6/uu/xlYBNvJv"
}

variable "kubernetes_version" {
  # https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengaboutk8sversions.htm
  description = "Version of Kubernetes"
  type        = string

  default     = "v1.28.2"
}

variable "kubernetes_worker_nodes" {
  description = "Worker node count"
  type        = number

  default     = 2
}

variable "image_id" {
  # https://docs.oracle.com/en-us/iaas/images/oke-worker-node-oracle-linux-8x/
  description = "OCID of the latest oracle linux"
  type        = string

  default     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaqc4pu3po5xhvpkeejm2yuqrymggvf73v7bqruk535x4skreclveq"
}

variable "achim_winter_domain_name" {
  description = "Main DNS Zone"
  type        = string

  default     = "achim-winter.eu"
}
