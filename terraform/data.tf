data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = [var.ami_owner] # Debian official owner

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
