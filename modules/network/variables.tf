variable "vpc_cidr" {
  type        = string
  description = "The base IP range (CIDR) for the entire VPC network"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The IP segment allocated for public-facing assets"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "The isolated IP segment allocated for backend compute workloads"
  default     = "10.0.2.0/24"
}

variable "environment" {
  type        = string
  description = "Deployment environment name tag"
  default     = "dev"
}

# --- Phase 2: Compute Predefined Variables ---
variable "instance_type" {
  type        = string
  description = "Predefined virtual machine hardware profile size"
  default     = "t3.micro"
}

variable "ssh_key_name" {
  type        = string
  description = "The name of the pre-configured secure shell access key pair"
  default     = "junior-devops-admin-key"
}
