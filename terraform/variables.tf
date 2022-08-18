# Network Specs 
variable "network_cidr" {
  description = "AWS VPC Network CIDR"
  type        = string
  default     = "192.168.50.0/24"
}
variable "network_subneta_private" {
  description = "AWS Subnet A PRIVATE"
  type        = string
  default     = "192.168.50.0/26"
}
variable "network_subnetb_private" {
  description = "AWS Subnet B PRIVATE"
  type        = string
  default     = "192.168.50.64/26"
}
variable "network_subnetc_private" {
  description = "AWS Subnet C PRIVATE"
  type        = string
  default     = "192.168.50.128/26"
}
variable "network_subneta_public" {
  description = "AWS Subnet A PUBLIC"
  type        = string
  default     = "192.168.50.192/28"
}
variable "network_subnetb_public" {
  description = "AWS Subnet B PUBLIC"
  type        = string
  default     = "192.168.50.208/28"
}
variable "network_subnetc_public" {
  description = "AWS Subnet C PUBLIC"
  type        = string
  default     = "192.168.50.224/28"
}

# Scale Nodes
variable "instance_controlplane_number" {
  description = "Number of controlplane instances"
  type        = number
  default     = 1
}
variable "instance_node_number" {
  description = "Number of node instances"
  type        = number
  default     = 2
}

# Instance Specs
variable "instance_controlplane_type" {
  description = "EC2 Type for the control Plane"
  type        = string
  default     = "t3a.small"
}
variable "instance_node_type" {
  description = "EC2 Type for the node"
  type        = string
  default     = "t3a.medium"
}

# Miscellaneous
variable "aws_region" {
  description = "AWS Region to use"
  type        = string
  default     = "eu-central-1"
}
variable "ami_owner" {
  description = "AMI Owner image id (debian)"
  type        = string
  default     = "136693071363"
}
variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "kubernetes-challengekt"
}
variable "global_tags" {
  description = "AWS Tags to use for all resources"
  type        = map(any)
  default = {
    "PROJECT"     = "CHALLENGE_KT",
    "CUSTOMER"    = "INTERNAL"
    "ENVIRONMENT" = "DEV",
    "TERRAFORM"   = "TRUE"
  }
}
variable "allowed_ip" {
  description = "Allowed ip to add in the Security group for SSH/K8S API"
  type        = list(string)
  default     = ["127.0.0.1/32"]
}
