output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "The ID of the public subnet for hosting web-facing compute assets"
}
output "private_subnet_id" {
  value = aws_subnet.private.id
}
output "security_group_id" {
  value = aws_security_group.compute_sg.id
}

output "instance_public_ip" {
  value       = aws_instance.backend_server.public_ip
  description = "The public IP address of the backend node"
}
