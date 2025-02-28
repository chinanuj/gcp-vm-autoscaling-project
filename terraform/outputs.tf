output "base_instance_ip" {
  description = "The external IP address of the base instance"
  value       = google_compute_instance.base_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_group_self_link" {
  description = "Self-link of the managed instance group"
  value       = google_compute_region_instance_group_manager.autoscaling_group.self_link
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.vm_manager.email
}