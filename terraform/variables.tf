variable "project_id" {
  description = "The GCP project ID"
  default     = "de-zoomcamp-485615"
}

variable "credentials" {
  description = "My GCP Credentials"
  default     = "./keys/my-creds.json"
}

variable "gcs_location_region" {
  description = "The region of the GCS bucket"
  default     = "us-central1"
}

variable "gcs_location" {
  description = "The location of the GCS bucket"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "The name of the BigQuery dataset to create"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "The name of the GCS bucket to create"
  default     = "de-zoomcamp-485615-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "The storage class of the GCS bucket"
  default     = "STANDARD"
}
