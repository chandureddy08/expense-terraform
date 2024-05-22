## PROJECT VARS  ## 
variable "project_name" {
    type = string
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map

}
## VPC VARS ##
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = "true"  
}
variable "vpc_tags" {
    type = map
    default = {}
}
## IGW TAGS ##
variable "igw_tags" {
    type = map
    default = {}
}

## PUBLIC SUBNET VARS ##
variable "public_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please provide 2 valid subnet CIDR"
    }
}
variable "public_subnet_cidrs_tags" {
    type = map
    default = {}
}

## PRIVATE SUBNET ##
variable "private_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.private_subnet_cidrs)  == 2
    error_message = "Please provide 2 valid subnet CIDR"
  }
}
variable "private_subnet_cidrs_tags" {
    type = map
    default = {}
}

## DATABASE VARS ##
variable "database_subnet_cidrs" {
    type = list
    validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "Please provide 2 valid subnet CIDR"
  }
}
variable "database_subnet_cidrs_tags" {
    type = map
    default = {}
}  

## NAT GATEWAY ##
variable "nat_gateway_tags" {
    type = map
    default = {}
}

## PUBLIC ROUTE TABLE VARS ##
variable "public_route_table_tags" {
    type = map
    default = {}
}

## PRIVATE ROUTE TABLE VARS ##
variable "private_route_table_tags" {
    type = map
    default = {}
}

## DATABASE ROUTE TABLE TAGS ##
variable "database_route_table_tags" {
    type = map
    default = {}
}

## PEERING ##
variable "is_peering_required" {
    type = bool
    default = false
}
variable "acceptor_vpc_id" {
    type = string
    default = ""
}
variable "vpc_peering_tags" {
    type = map
    default = {}
}
variable "aws_db_subnet_group_tags" {
    type = map
    default = {}
}