variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "vpc_id" {
  type        = string
  description = "The target network ID passed dynamically from our network module output"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "public_subnet_id" {
  type        = string
  description = "The public subnet ID forwarded from the network tier"
}

variable "key_name" {
  type        = string
  description = "The registered administrative SSH key pair name"
}
