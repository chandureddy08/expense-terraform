module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"
  ami = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  # CONVERT FROM STRINGLIST TO LIST AND GET FIRST ELEMENT
  subnet_id              = local.public_subnet_id
  user_data = file("bastion.sh")

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}