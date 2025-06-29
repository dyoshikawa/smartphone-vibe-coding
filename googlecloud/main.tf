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
  default     = "us-west2"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-west2-a"
}

variable "instance_name" {
  description = "GCE Instance Name"
  type        = string
  default     = "managed-instance"
}

variable "ssh_keys" {
  description = "SSH keys to be added to instance metadata (format: 'username:ssh-rsa ...')"
  type        = string
}

# Enable required APIs
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudfunctions_api" {
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudscheduler_api" {
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild_api" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}


# GCE Instance
resource "google_compute_instance" "managed_instance" {
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
    access_config {}
  }

  metadata = {
    startup-script = "#!/bin/bash\napt-get update\napt-get install -y nginx\nsystemctl start nginx\nsystemctl enable nginx"
    ssh-keys       = var.ssh_keys
  }

  tags = ["http-server", "https-server"]
}

# Service Account for Cloud Functions
resource "google_service_account" "function_sa" {
  account_id   = "instance-manager-sa"
  display_name = "Instance Manager Service Account"
}

# IAM bindings for the service account
resource "google_project_iam_member" "compute_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}

# Cloud Storage bucket for function source code
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-function-source"
  location = var.region
}

# Create source code for start instance function
data "archive_file" "start_function_zip" {
  type        = "zip"
  output_path = "start_function.zip"
  source {
    content  = <<-EOT
import functions_framework
from google.cloud import compute_v1
import os

@functions_framework.http
def start_instance(request):
    project_id = os.environ.get('PROJECT_ID')
    zone = os.environ.get('ZONE')
    instance_name = os.environ.get('INSTANCE_NAME')
    
    instance_client = compute_v1.InstancesClient()
    
    try:
        operation = instance_client.start(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        
        return f"Instance {instance_name} start operation initiated: {operation.name}", 200
    except Exception as e:
        return f"Error starting instance: {str(e)}", 500
EOT
    filename = "main.py"
  }
  source {
    content  = <<-EOT
functions-framework==3.*
google-cloud-compute==1.*
EOT
    filename = "requirements.txt"
  }
}

# Upload start function source to bucket
resource "google_storage_bucket_object" "start_function_source" {
  name   = "start_function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.start_function_zip.output_path

  depends_on = [data.archive_file.start_function_zip]
}

# Cloud Function to start instance (with web URL, no auth) - Gen 1
resource "google_cloudfunctions_function" "start_instance" {
  name        = "start-instance"
  description = "Start GCE instance"
  runtime     = "python39"
  region      = var.region

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_storage_bucket_object.start_function_source
  ]

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.start_function_source.name
  trigger_http          = true
  entry_point           = "start_instance"

  service_account_email = google_service_account.function_sa.email

  environment_variables = {
    PROJECT_ID    = var.project_id
    ZONE          = var.zone
    INSTANCE_NAME = var.instance_name
  }
}

# Make start function publicly accessible
resource "google_cloudfunctions_function_iam_member" "start_invoker" {
  project        = google_cloudfunctions_function.start_instance.project
  region         = google_cloudfunctions_function.start_instance.region
  cloud_function = google_cloudfunctions_function.start_instance.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# Create source code for stop instance function
data "archive_file" "stop_function_zip" {
  type        = "zip"
  output_path = "stop_function.zip"
  source {
    content  = <<-EOT
import functions_framework
from google.cloud import compute_v1
import os

@functions_framework.http
def stop_instance(request):
    project_id = os.environ.get('PROJECT_ID')
    zone = os.environ.get('ZONE')
    instance_name = os.environ.get('INSTANCE_NAME')
    
    instance_client = compute_v1.InstancesClient()
    
    try:
        operation = instance_client.stop(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        
        return f"Instance {instance_name} stop operation initiated: {operation.name}", 200
    except Exception as e:
        return f"Error stopping instance: {str(e)}", 500
EOT
    filename = "main.py"
  }
  source {
    content  = <<-EOT
functions-framework==3.*
google-cloud-compute==1.*
EOT
    filename = "requirements.txt"
  }
}

# Upload stop function source to bucket
resource "google_storage_bucket_object" "stop_function_source" {
  name   = "stop_function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.stop_function_zip.output_path

  depends_on = [data.archive_file.stop_function_zip]
}

# Cloud Function to stop instance (with web URL, no auth) - Gen 1
resource "google_cloudfunctions_function" "stop_instance" {
  name        = "stop-instance"
  description = "Stop GCE instance"
  runtime     = "python39"
  region      = var.region

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_storage_bucket_object.stop_function_source
  ]

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.stop_function_source.name
  trigger_http          = true
  entry_point           = "stop_instance"

  service_account_email = google_service_account.function_sa.email

  environment_variables = {
    PROJECT_ID    = var.project_id
    ZONE          = var.zone
    INSTANCE_NAME = var.instance_name
  }
}

# Make stop function publicly accessible
resource "google_cloudfunctions_function_iam_member" "stop_invoker" {
  project        = google_cloudfunctions_function.stop_instance.project
  region         = google_cloudfunctions_function.stop_instance.region
  cloud_function = google_cloudfunctions_function.stop_instance.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# Create source code for scheduled stop function
data "archive_file" "scheduled_stop_function_zip" {
  type        = "zip"
  output_path = "scheduled_stop_function.zip"
  source {
    content  = <<-EOT
import functions_framework
from google.cloud import compute_v1
import os
import json

@functions_framework.cloud_event
def scheduled_stop_instance(cloud_event):
    project_id = os.environ.get('PROJECT_ID')
    zone = os.environ.get('ZONE')
    instance_name = os.environ.get('INSTANCE_NAME')
    
    instance_client = compute_v1.InstancesClient()
    
    try:
        operation = instance_client.stop(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        
        print(f"Instance {instance_name} stop operation initiated: {operation.name}")
        return f"Instance {instance_name} stop operation initiated: {operation.name}"
    except Exception as e:
        print(f"Error stopping instance: {str(e)}")
        raise e
EOT
    filename = "main.py"
  }
  source {
    content  = <<-EOT
functions-framework==3.*
google-cloud-compute==1.*
EOT
    filename = "requirements.txt"
  }
}

# Upload scheduled stop function source to bucket
resource "google_storage_bucket_object" "scheduled_stop_function_source" {
  name   = "scheduled_stop_function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.scheduled_stop_function_zip.output_path

  depends_on = [data.archive_file.scheduled_stop_function_zip]
}

# Pub/Sub topic for scheduled function
resource "google_pubsub_topic" "stop_instance_topic" {
  name = "stop-instance-topic"
}

# Cloud Function for scheduled stop (no web URL) - Gen 1
resource "google_cloudfunctions_function" "scheduled_stop_instance" {
  name        = "scheduled-stop-instance"
  description = "Stop GCE instance on schedule"
  runtime     = "python39"
  region      = var.region

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_storage_bucket_object.scheduled_stop_function_source
  ]

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.scheduled_stop_function_source.name

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.stop_instance_topic.name
  }
  entry_point = "scheduled_stop_instance"

  service_account_email = google_service_account.function_sa.email

  environment_variables = {
    PROJECT_ID    = var.project_id
    ZONE          = var.zone
    INSTANCE_NAME = var.instance_name
  }
}

# Cloud Scheduler job to stop instance at midnight
resource "google_cloud_scheduler_job" "stop_instance_job" {
  name        = "stop-instance-midnight"
  description = "Stop instance at midnight"
  schedule    = "0 0 * * *"
  time_zone   = "Asia/Tokyo"
  region      = var.region

  depends_on = [google_project_service.cloudscheduler_api]

  pubsub_target {
    topic_name = google_pubsub_topic.stop_instance_topic.id
    data       = base64encode(jsonencode({ "action" : "stop" }))
  }
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
  description = "Name of the managed instance"
  value       = google_compute_instance.managed_instance.name
}

output "instance_zone" {
  description = "Zone of the managed instance"
  value       = google_compute_instance.managed_instance.zone
}

