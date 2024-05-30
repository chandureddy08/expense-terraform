variable "project_name" {
    type = string
    default = "expense"
}
variable "environment" {
    type = string
    default = "dev"
}
variable "ami_id" {
    type = string
    default = "ami-090252cbe067a9e58"
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
