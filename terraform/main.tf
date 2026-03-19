# --- Enable Required APIs ---

resource "google_project_service" "cloudbuild" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "developerconnect" {
  service            = "developerconnect.googleapis.com"
  disable_on_destroy = false
}

# --- GCS Bucket for Static Site ---

resource "google_storage_bucket" "main" {
  name          = "${var.bucket_name}-${var.project_id}"
  location      = var.region
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "project_read" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectViewer"
  member = "projectViewer:${var.project_id}"
}

# --- Cloud Build Service Account Permissions ---

data "google_project" "main" {}

resource "google_project_iam_member" "cloudbuild_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${data.google_project.main.number}@cloudbuild.gserviceaccount.com"
}

# --- Developer Connect (Cloud Build v2) ---

resource "google_cloudbuildv2_connection" "main" {
  location = var.region
  name     = var.developer_connect_connection

  github_config {
    app_installation_id = var.github_app_installation_id
  }

  depends_on = [google_project_service.developerconnect]
}

resource "google_cloudbuildv2_repository" "main" {
  location          = var.region
  name              = "tinyjam"
  parent_connection = google_cloudbuildv2_connection.main.name
  remote_uri        = var.github_remote_uri

  depends_on = [google_cloudbuildv2_connection.main]
}

# --- Cloud Build Trigger ---

resource "google_cloudbuild_trigger" "main" {
  name     = "tinyjam-push-to-master"
  location = var.region

  repository_event_config {
    repository = google_cloudbuildv2_repository.main.id

    push {
      branch = "^master$"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _BUCKET_NAME = google_storage_bucket.main.name
  }

  depends_on = [google_project_service.cloudbuild]
}
