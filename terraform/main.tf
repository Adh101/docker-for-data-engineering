terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  ##credentials = file("</workspaces/docker-for-data-engineering/terraform/keys/my-creds.json")
  project = "de-zoomcamp-485615"
  region  = "us-central1"
}

resource "google_storage_bucket" "de_zoomcamp_485615_terraform_bucket" {
  name          = "de-zoomcamp-485615-terraform-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}