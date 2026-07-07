resource "local_file" "storage_manifest" {
  filename = "${path.module}/../../environments/${var.environment}/storage_state.json"
  content  = <<EOT
{
  "bucket_name": "${var.bucket_name}",
  "lifecycle_policy": "Delete objects older than 30 days",
  "access_control": "Private (Bucket Owner Full Control)",
  "encryption": "AES-256-Managed"
}
EOT
}
