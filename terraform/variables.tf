variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "sdlc-test-project-jianxiwang"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the GCS bucket for the static site"
  type        = string
  default     = "tinyjam-static-site"
}

variable "github_remote_uri" {
  description = "The GitHub repository URI"
  type        = string
  default     = "https://github.com/CoasterJX/tinyjam.git"
}

variable "developer_connect_connection" {
  description = "The Cloud Build v2 connection name"
  type        = string
  default     = "tinyjam-github-connection"
}

variable "github_app_installation_id" {
  description = "The GitHub App installation ID (obtain from GitHub after installing the Cloud Build app)"
  type        = number
}
