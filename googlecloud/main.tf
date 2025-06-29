terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "asia-northeast1-a"
}

variable "instance_name" {
  description = "GCE Instance Name"
  type        = string
  default     = "coding-instance"
}

variable "ssh_keys" {
  description = "SSH keys to be added to instance metadata (format: 'username:ssh-rsa ...')"
  type        = string
}


# Output important URLs and information
output "start_function_url" {
  description = "URL to start the instance"
  value       = google_cloudfunctions_function.start_instance.https_trigger_url
}

output "stop_function_url" {
  description = "URL to stop the instance"
  value       = google_cloudfunctions_function.stop_instance.https_trigger_url
}

output "instance_name" {
  description = "Name of the coding instance"
  value       = google_compute_instance.coding_instance.name
}

output "instance_zone" {
  description = "Zone of the coding instance"
  value       = google_compute_instance.coding_instance.zone
}

