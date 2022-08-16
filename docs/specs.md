# Network Specs

VPC CIDR: `192.168.50.0/24`

Subnet A (private): `192.168.50.0/26`

Subnet B (private): `192.168.50.64/26`

Subnet C (private): `192.168.50.128/26`

Subnet A (public); `192.168.50.192/28`

Subnet B (public): `192.168.50.208/28`

Subnet C (public): `192.168.50.224/28`

Subnet Service POD (into k8s): `10.233.0.0/18`

Subnet POD (into k8s): `10.233.64.0/18`

# Operation System

Os: `Debian 11`

Arch: `amd64`

Version: `Latest Official AMI`

# Kubernetes Specs

Version: `1.23.7`

Network Addon: `Calico`

Addons:
* `Cert Manager`
* `Helm`
* `Ingress ALB`
* `Metrics Server`