pipeline {
    agent {
        docker {
            image 'alpine:3.16'
        }
    }
    environment {
        TERRAFORM_VERSION="1.2.7"
        TFSEC_VERSION="1.27.1"
        TFLINT_VERSION="0.39.3"
        HELM_VERSION="3.9.3"
        AWS_PROFILE="DEVLAB"
        TARGET_REPO="https://github.com/Mirio/Challenge-kt"
        TEMP_DIR="/tmp/tmpdir"
    }
    stages {
        stage('Pre-Requisites') {
            steps {
                sh "apk add --no-cache alpine-sdk bash ca-certificates git python3 python3-dev py3-pip wget zip"
                dir("${TEMP_DIR}") {
                    // Install Terraform (https://github.com/hashicorp/terraform)
                    sh "wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/local/bin && chmod +x /usr/local/bin/terraform"
                    // Install TfSec (https://github.com/aquasecurity/tfsec)
                    sh "wget https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec_${TFSEC_VERSION}_linux_amd64.tar.gz && tar xfz tfsec_${TFSEC_VERSION}_linux_amd64.tar.gz && mv tfsec /usr/local/bin && chmod +x /usr/local/bin/tfsec"
                    // Install TFLint (https://github.com/terraform-linters/tflint)
                    sh "wget https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && unzip tflint_linux_amd64.zip && mv tflint /usr/local/bin && chmod +x /usr/local/bin/tflint"
                    // Install CheckOV (https://github.com/bridgecrewio/checkov)
                    sh "pip3 install checkov"
                    // Install Ansible Lint
                    sh "pip3 install ansible-lint==5.4.0"
                    // Install Helm
                    sh "wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && tar xfz helm-v${HELM_VERSION}-linux-amd64.tar.gz && cd linux-amd64/ && mv helm /usr/local/bin/ && chmod +x /usr/local/bin/helm"
                }
                git "${TARGET_REPO}"
            }
        }
        stage('Code Validate') {
            parallel {
                stage('Terraform Validate') {
                    steps {
                        dir("Challenge-kt") {
                            // Terraform FMT check
                            sh "terraform fmt -recursive terraform/"
                            // Tfsec Check
                            sh "tfsec terraform/"
                            // Tflint check
                            sh "tflint terraform/"
                            // CheckOV check
                            sh "checkov -d terraform/"
                        }
                    }
                }
                stage('Ansible Validate') {
                    steps {
                        dir("Challenge-kt/ansible") {
                            sh "ansible-lint custom/"
                        }
                    }
                }
                stage('Helm Validate') {
                    steps {
                        dir("Challenge-kt/argocd/helm") {
                            sh "helm lint *"
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                dir("Challenge-kt/terraform") {
                    sh "terraform init && terraform apply -auto-approve"
                }
                dir("Challenge-kt/ansible") {
                    sh "bash update.bash"
                }
            }
        }
    }
}
