variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
}

variable "dashboard_enabled" {
  type        = bool
  description = "Enable Traefik Dashboard"
  default     = true
}

variable "dashboard_host" {
  type        = string
  description = "Hostname for Traefik Dashboard"
  default     = "traefik.winter-achim.de"
}

variable "replica_count" {
  type        = number
  description = "Number of Traefik replicas"
  default     = 2
}

variable "lb_shape_min" {
  type        = string
  description = "Minimum OCI LoadBalancer shape bandwidth in Mbps"
  default     = "10"
}

variable "lb_shape_max" {
  type        = string
  description = "Maximum OCI LoadBalancer shape bandwidth in Mbps"
  default     = "10"
}
