module "db" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Database instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}
module "backend" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Backend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}
module "frontend" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Frontend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}

# DB is accepting connection from backend
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.backend.sg_id
}

# Backend is accepting connection from frontend
resource "aws_security_group_rule" "backend_frontend" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.frontend.sg_id
}

# Frontend is accepting public
resource "aws_security_group_rule" "frontend_public" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}