provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

# Create instance template
resource "google_compute_instance_template" "template" {
  name         = "assignment-2-template"
  machine_type = "e2-medium"
  tags         = ["http-server", "https-server"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}  # Gives external IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Create managed instance group with autoscaling
resource "google_compute_region_instance_group_manager" "mig" {
  name                      = "assignment-2-mig"
  base_instance_name        = "assignment-2-mig-instance"
  region                    = var.region
  distribution_policy_zones = [var.zone]
  
  version {
    instance_template = google_compute_instance_template.template.id
  }

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }
}

# Create autoscaler for the MIG
resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "assignment-2-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

# Create firewall rules for HTTP/HTTPS traffic
resource "google_compute_firewall" "allow_http_custom" {
  name          = "allow-http-custom"
  network       = "default"
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.allowed_ip]
  target_tags   = ["http-server"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow_https_custom" {
  name          = "allow-https-custom"
  network       = "default"
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.allowed_ip]
  target_tags   = ["https-server"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}