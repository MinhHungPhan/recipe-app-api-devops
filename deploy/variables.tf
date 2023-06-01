variable "prefix" {
    default = "raad" #raad = recipe-app-api-devops
}

variable "project" {
  default = "recipe-app-api-devops"
}

variable "contact" {
  default = "email@kientree.com"
}

variable "db_username" {
  description = "Username for the RDS postgres instance"
}

variable "db_password" {
  description = "Password for the RDS postgres instance"
}