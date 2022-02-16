variable "zone" {
  description = "for single zone deployment"
  default = "europe-west4-b"
}

variable "zones" {
  description = "for multi zone deployment"
  default = ["europe-west4-b", "europe-west4-c"]
}
