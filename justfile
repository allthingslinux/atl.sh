# atl.sh — just recipes
# Run `just` to list available commands

# List all available recipes
default:
    @just --list

# Install Ansible collections and roles
install:
    ansible-galaxy install -r ansible/requirements.yml -p .ansible --force

# Terraform — initialize backend and providers
tf-init:
    cd terraform && terraform init

# Terraform — show planned changes
tf-plan:
    cd terraform && terraform plan

# Terraform — apply changes to infrastructure
tf-apply:
    cd terraform && terraform apply

# Deploy: dev (Vagrant VM), staging (Hetzner VPS), prod (physical)
deploy target:
    #!/usr/bin/env bash
    if [ "{{ target }}" = "dev" ]; then
        cd ansible && ansible-playbook site.yml -l dev --skip-tags security,env
    else
        cd ansible && ansible-playbook site.yml -l "{{ target }}"
    fi

# Deploy specific roles by tag (e.g. common,packages,users)
deploy-tag target tag:
    #!/usr/bin/env bash
    if [ "{{ target }}" = "dev" ]; then
        cd ansible && ansible-playbook site.yml -l dev --tags "{{ tag }}" --skip-tags security,env
    else
        cd ansible && ansible-playbook site.yml -l "{{ target }}" --tags "{{ tag }}"
    fi

# Create pubnix user account (target: staging or prod)
create-user username key target:
    cd ansible && ansible-playbook playbooks/create-user.yml -e "username={{ username }}" -e "ssh_public_key='{{ key }}'" -e "target_hosts={{ target }}"

# Remove pubnix user account (target: staging or prod)
remove-user username target:
    cd ansible && ansible-playbook playbooks/remove-user.yml -e "username={{ username }}" -e "target_hosts={{ target }}"

# Development environment (Vagrant + libvirt; requires .ssh/dev_key.pub)
dev-up:
    VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up

# Halt dev VM
dev-down:
    vagrant halt

# Run pre-commit hooks on all files
lint:
    pre-commit run --all-files

# Edit Ansible vault (secrets)
vault-edit:
    ansible-vault edit ansible/inventory/group_vars/all/vault.yml
