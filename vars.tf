variable "instance_count" {
  type = number
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
