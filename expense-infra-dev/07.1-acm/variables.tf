variable "project_name" {
    type = string
    default = "expense"
}
variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        Component = "backend"
    }
}
variable "zone_name" {
    type = string
  default = "chandureddy.online"
}
variable "zone_id" {
    type = string
    default = "Z1007947UZZMRR34QF56"
}