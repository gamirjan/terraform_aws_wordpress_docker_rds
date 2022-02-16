variable "instance_count" {
  description = "for single zone deployment"
}

variable "zones" {
  type        = list(string)
  description = "Availablity zones"
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


