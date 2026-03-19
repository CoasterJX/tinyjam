output "static_site_url" {
  description = "The public URL of the static site"
  value       = "https://storage.googleapis.com/${google_storage_bucket.main.name}/index.html"
}

output "bucket_name" {
  description = "The GCS bucket name"
  value       = google_storage_bucket.main.name
}

output "trigger_id" {
  description = "The Cloud Build trigger ID"
  value       = google_cloudbuild_trigger.main.trigger_id
}
