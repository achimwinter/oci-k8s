# output "longhorn_login" {
#   value = module.longhorn.longhorn_login

#   sensitive = true
# }

output "load_balancer_ip" {
  value = module.traefik.load_balancer_ip
}
