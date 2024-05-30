resource "aws_key_pair" "vpn" {
   # you can paste the public key directly like this
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ONJth+DzeXbU3oGATxjVmoRjPepdl7sBuPzzQT2"
  key_name = "vpn"
  public_key = file("~/.ssh/vpn.pub")
  # ~ means windows home
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-vpn"
  ami = data.aws_ami.ami_info.id
  key_name = aws_key_pair.vpn.key_name
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # CONVERT FROM STRINGLIST TO LIST AND GET FIRST ELEMENT
  subnet_id = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}