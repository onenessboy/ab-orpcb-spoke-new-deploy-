
variable "location" {
  type        = string
  description = "Location of the Resource Group"
}

variable "tags" {
  type        = map(string)
  default     = {
}
  description = "A mapping of tags which should be assigned to the Resource Group"
}

variable "client_code" {
  type = string
}

variable "env" {
  type = string
}

variable "locationcode"{
  type = any
  default = {
     westeurope = "we",
     eastus = "eus"
  }
}