variable "bucket_name" {
  type        = string
  description = "The globally unique name of the storage bucket artifact repository"
}

variable "environment" {
  type    = string
  default = "dev"
}
