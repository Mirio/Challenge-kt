# Virtual Machine Deployer Tool
Terraform is the standard "the facto" for the infrastructure deployment and has more support and documentation than [Pulumi](https://www.pulumi.com/).

I choose to not use the [Kubespray Terraform Contrib](https://github.com/kubernetes-sigs/kubespray/tree/master/contrib/terraform) to demonstrate my terraform skills and increase flexibility.
 
# Ansible Deployer tool
Kubespray is the only multi-node **Production Ready** certified by Kubernetes developer and managed directly in the same orgs. 

It can support multiple clouds and it is not a cloud lock-in feature.

# Terraform Scanning Tools
All the codes are scanned and validated with:
* [TFSec](https://github.com/aquasecurity/tfsec)
* [TFLint](https://github.com/terraform-linters/tflint)
* [CheckOV](https://github.com/bridgecrewio/checkov)
* Terraform FMT

# Ansible Scanning Tools
All the ansible codes are validated with `ansible-lint`

# Kubernetes Security Benchmark
I choose to use [Kube-Bench](https://github.com/aquasecurity/kube-bench) because:
* Frequent release with new rules
* No external deps (it can easily deployed directly on the cluster)
* Include many CIS rules on it