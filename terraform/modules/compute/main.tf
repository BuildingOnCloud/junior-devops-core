resource "local_file" "compute_manifest" {
  filename = "${path.module}/../../environments/${var.environment}/compute_state.json"
  content  = <<EOT
{
  "instance_name": "srv-${var.environment}-app-node",
  "instance_type": "${var.instance_type}",
  "attached_vpc": "${var.vpc_id}",
  "os_image": "Ubuntu-Server-22.04-LTS",
  "assigned_private_ip": "10.0.2.45",
  "security_groups": ["sg-app-server-ingress"],
  "iam_role": "SSM-Managed-Instance-Core"
}
EOT
}
