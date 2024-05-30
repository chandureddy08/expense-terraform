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
    }
}
variable "db_sg_desciption" {
    default = "SG for DB Mysql Instances"
}
variable "zone_name" {
    type = string
    default = "chandureddy.online"
}