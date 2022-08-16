resource "tls_private_key" "ssh_key_private" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_key_private_file" {
  content         = tls_private_key.ssh_key_private.private_key_openssh
  filename        = "out/sshkey"
  file_permission = "0400"
}

resource "local_file" "ssh_key_public_file" {
  content         = tls_private_key.ssh_key_private.public_key_openssh
  filename        = "out/sshkey.pub"
  file_permission = "0600"
}

resource "aws_key_pair" "main_keypair" {
  key_name   = "challengekt_host_keypair"
  public_key = tls_private_key.ssh_key_private.public_key_openssh
  tags       = merge(var.global_tags, { "Name" : "CHALLENGEKT" })
}

resource "aws_instance" "instance_controlplane" {
  count             = var.instance_controlplane_number
  ami               = data.aws_ami.instance_ami.id
  instance_type     = var.instance_controlplane_type
  availability_zone = "${var.aws_region}a"
  # To be deactivated/switch to private net in production or setup a bastion host on top
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_public_a.id
  # To be deactivated/switch to private net in production or setup a bastion host on top
  key_name               = aws_key_pair.main_keypair.key_name
  vpc_security_group_ids = [aws_security_group.main_sg_controlplan.id]
  iam_instance_profile   = aws_iam_role.iam_controlplane_role.id
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 50
    volume_type           = "gp3"
    tags                  = merge(var.global_tags, { "Name" : "CHALLENGEKT-ROOT-CONTROLPLANE${count.index}" })
  }
  user_data = filebase64("assets/userdata.bash")
  tags = merge(
    var.global_tags, { "Name" : "challengekt-cp${count.index}" },
    { "kubernetes.io/cluster/${var.cluster_name}" : "shared" },
    { "kubespray-role" : "kube_control_plane, etcd" }
  )
}

resource "aws_instance" "instance_node" {
  count         = var.instance_node_number
  ami           = data.aws_ami.instance_ami.id
  instance_type = var.instance_node_type
  # To be deactivated/switch to private net in production or setup a bastion host on top
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet_public_b.id
  # To be deactivated/switch to private net in production or setup a bastion host on top
  availability_zone      = "${var.aws_region}b"
  key_name               = aws_key_pair.main_keypair.key_name
  vpc_security_group_ids = [aws_security_group.main_sg_node.id]
  iam_instance_profile   = aws_iam_role.iam_node_role.id
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 50
    volume_type           = "gp3"
    tags                  = merge(var.global_tags, { "Name" : "CHALLENGEKT-ROOT-NODE${count.index}" }, )
  }
  user_data = filebase64("assets/userdata.bash")
  tags = merge(
    var.global_tags, { "Name" : "challengekt-node${count.index}" },
    { "kubernetes.io/cluster/${var.cluster_name}" : "shared" },
    { "kubespray-role" : "kube_node" }
  )
}
