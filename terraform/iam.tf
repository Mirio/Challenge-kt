resource "aws_iam_role" "iam_controlplane_role" {
  name = "CHALLENGEKT-CONTROLPLANE"
  tags = var.global_tags

  assume_role_policy = file("policies/assume-role.json")
  inline_policy {
    name = "CHALLENGEKT-CONTROLPLANE"
    # KubeSpray default policy https://github.com/kubernetes-sigs/kubespray/blob/master/contrib/aws_iam/kubernetes-master-policy.json
    policy = file("policies/controlplane-policy.json")
  }
}

resource "aws_iam_instance_profile" "iam_controlplane_role_instancerole" {
  name = "CHALLENGEKT-CONTROLPLANE"
  role = aws_iam_role.iam_controlplane_role.name
}

resource "aws_iam_role" "iam_node_role" {
  name = "CHALLENGEKT-NODE"
  tags = var.global_tags

  assume_role_policy = file("policies/assume-role.json")
  inline_policy {
    name = "CHALLENGEKT-NODE"
    # KubeSpray Default policy https://github.com/kubernetes-sigs/kubespray/blob/master/contrib/aws_iam/kubernetes-minion-policy.json
    policy = file("policies/node-policy.json")
  }
}

resource "aws_iam_instance_profile" "iam_node_role_instancerole" {
  name = "CHALLENGEKT-NODE"
  role = aws_iam_role.iam_node_role.name
}
