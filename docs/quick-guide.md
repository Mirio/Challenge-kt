# Bootstrap
## Terraform Steps
Jump on the `terraform` directory.

* Edit `variables.tf` and insert your IP in the variable `allowed_ip`
* Edit `backend.tf` and insert your s3 bucket for the terraform state
* Do a `terraform init && terraform apply -auto-approve` 

## Ansible Steps
Jump on the `ansible` directory.

The sleep is needed to apply the user-data and reboot the machine to apply the kernel flags needed for Debian [Kubespray Docs](https://kubespray.io/#/docs/debian)
`sleep 120 && bash deploy.bash`

Bootstrap complete.

# Continuous Integration
You need to configure the Jenkins CI using the `Jenkinsfile` in the root of the directory

# How does it work?
[Infrastructure](infra.jpg)

# Connect to the Service
## WordPress Web Interface
Export this variable

`export KUBECONFIG="${PWD}/ansible/inventory/kubernetes-challengekt/artifacts/admin.conf"`

`kubectl port-forward -n kiratech-test svc/wordpress 8080:80`

Open your browser to [https://127.0.0.1:8080](https://127.0.0.1:8080)

## ARGOCD
Export this variable

`export KUBECONFIG="${PWD}/ansible/inventory/kubernetes-challengekt/artifacts/admin.conf"`

`kubectl port-forward -n argocd svc/argocd-server 8080:443`

Open your browser to [http://127.0.0.1:8080](http://127.0.0.1:8080)

User: `admin`

The password are in the secret, you can get it: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`