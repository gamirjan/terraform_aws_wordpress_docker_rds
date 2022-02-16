variable "instance_count" {
  description = "for single zone deployment"
  default     = 2
}

variable "zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
