variable "cloud-id" {
  description = "YCloud cloud ID"
  type        = string
}

variable "folder-id" {
  description = "YCloud folder ID"
  type        = string
}

# variable "service-account-id" {
#   description = "Service Account"
#   type        = string
# }

variable "wireguard-server-port" {
  description = "WireGuard server port"
  type        = number
  default     = 51820
}
