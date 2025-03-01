output "instance_template_self_link" {
  value       = google_compute_instance_template.template.self_link
  description = "Self-link of the created instance template"
}

output "managed_instance_group_self_link" {
  value       = google_compute_region_instance_group_manager.mig.self_link
  description = "Self-link of the created managed instance group"
}

output "autoscaler_self_link" {
  value       = google_compute_region_autoscaler.autoscaler.self_link
  description = "Self-link of the created autoscaler"
}