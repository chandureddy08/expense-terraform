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
        Component = "app-alb"
    }
}
variable "zone_name" {
    default = "chandureddy.online"
}