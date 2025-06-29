# Enable required APIs for compute
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Firewall rule for Tailscale
resource "google_compute_firewall" "tailscale_udp" {
  name    = "allow-tailscale-udp"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["41641"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["tailscale"]
}

# GCE Instance with Tailscale
resource "google_compute_instance" "coding_instance" {
  name         = var.instance_name
  machine_type = "e2-medium"
  zone         = var.zone

  depends_on = [google_project_service.compute_api]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    # Enable IP forwarding for Tailscale subnet routing
    # Comment out access_config to remove public IP if needed
    access_config {}
  }

  can_ip_forward = true

  metadata = {
    ssh-keys = var.ssh_keys
  }

  tags = ["http-server", "https-server", "tailscale"]
}