provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Create a VM instance
resource "google_compute_instance" "base_instance" {
  name         = "base-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file("${path.module}/../scripts/startup-script.sh")

  tags = ["http-server", "https-server"]

  service_account {
    email  = google_service_account.vm_manager.email
    scopes = ["cloud-platform"]
  }
}

# Create a service account
resource "google_service_account" "vm_manager" {
  account_id   = "vm-manager"
  display_name = "VM Manager Service Account"
}

# Assign IAM roles to service account
resource "google_project_iam_member" "vm_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.vm_manager.email}"
}

resource "google_project_iam_member" "network_user" {
  project = var.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.vm_manager.email}"
}

# Create an instance template
resource "google_compute_instance_template" "autoscale_template" {
  name         = "autoscale-template"
  machine_type = "e2-medium"
  
  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file("${path.module}/../scripts/startup-script.sh")

  tags = ["http-server", "https-server"]

  service_account {
    email  = google_service_account.vm_manager.email
    scopes = ["cloud-platform"]
  }
}

# Create a health check
resource "google_compute_health_check" "http_health_check" {
  name               = "http-health-check"
  check_interval_sec = 30
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

# Create a managed instance group
resource "google_compute_region_instance_group_manager" "autoscaling_group" {
  name               = "autoscaling-group"
  base_instance_name = "autoscaling-group"
  region             = var.region
  
  version {
    instance_template = google_compute_instance_template.autoscale_template.id
  }
  
  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_health_check.id
    initial_delay_sec = 120
  }
}

# Set up autoscaling
resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.autoscaling_group.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}

# Create firewall rules
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.your_ip_address]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "allow_web" {
  name    = "allow-web"
  network = "default"
  priority = 1100

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "deny_all_ingress" {
  name    = "deny-all-ingress"
  network = "default"
  priority = 2000

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}