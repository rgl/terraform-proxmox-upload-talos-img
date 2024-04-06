# About

Build a [Talos Linux](https://www.talos.dev) image and upload it into [Proxmox](https://www.proxmox.com/en/proxmox-virtual-environment/overview).

# Usage (Ubuntu 22.04 host)

Install Docker.

Install qemu-img:

```bash
apt-get install -y qemu-utils
```

Install Terraform:

```bash
# see https://github.com/hashicorp/terraform/releases
# renovate: datasource=github-releases depName=hashicorp/terraform
terraform_version='1.7.5'
wget "https://releases.hashicorp.com/terraform/$terraform_version/terraform_${$terraform_version}_linux_amd64.zip"
unzip "terraform_${$terraform_version}_linux_amd64.zip"
sudo install terraform /usr/local/bin
rm terraform terraform_*_linux_amd64.zip
```

Set your proxmox details:

```bash
# see https://registry.terraform.io/providers/bpg/proxmox/latest/docs#argument-reference
# see https://github.com/bpg/terraform-provider-proxmox/blob/v0.51.1/proxmoxtf/provider/provider.go#L49-L56
cat >secrets-proxmox.sh <<EOF
unset HTTPS_PROXY
#export HTTPS_PROXY='http://localhost:8080'
export TF_VAR_proxmox_pve_node_address='192.168.1.21'
export PROXMOX_VE_INSECURE='1'
export PROXMOX_VE_ENDPOINT="https://$TF_VAR_proxmox_pve_node_address:8006"
export PROXMOX_VE_USERNAME='root@pam'
export PROXMOX_VE_PASSWORD='vagrant'
EOF
source secrets-proxmox.sh
```

Build the talos image and initialize terraform:

```bash
./do init
```

Upload the talos image into Proxmox:

```bash
time ./do plan-apply
```

Destroy the image from Proxmox:

```bash
time ./do destroy
```
