variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "allowed_ip" {
  description = "IP address allowed to access HTTP/HTTPS services"
  type        = string
  default     = "223.238.204.234/32"
}