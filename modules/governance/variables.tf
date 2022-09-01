locals {
  root_compartment = var.root_compartment
  name = var.name
  description = var.description
  
  freeform_tags = {
    app-code = var.app_code
    factory = var.factory
    environment = var.environment
  } 
}

variable "root_compartment" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_code" {
  type = string
}

variable "factory" {
  type = string
}
