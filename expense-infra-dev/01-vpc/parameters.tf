resource "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
    type = "String"
    value = module.expense_vpc.vpc_id
}
resource "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
    type = "StringList"
    value = join(",", module.expense_vpc.public_subnet_ids) # CONVERTING LIST TO STRING LIST
}
resource "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
    type = "StringList"
    value = join(",", module.expense_vpc.private_subnet_ids) # CONVERTING LIST TO STRING LIST
}

# ["id1","id2"] --> terraform format
# id1, id2 --> aws SSM format

resource "aws_ssm_parameter" "db_subnet_group_name" {
    name = "/${var.project_name}/${var.environment}/db_subnet_group_name"
    type = "String"
    value = module.expense_vpc.database_subnet_group_name
}