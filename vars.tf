variable "instance_count" {
  description = "for single zone deployment"
  default     = 2
}

variable "zones" {
  type        = list(string)
  description = "Availablity zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  sensitive = true
  type      = string
}


