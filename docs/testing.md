# Local Docker Development Environment

Test Ansible playbooks locally using Docker before deploying to staging/production.

## Environments

- **dev** (Docker): Local container for rapid testing
- **staging** (Terraform): Cloud instance for pre-production validation
- **production** (Terraform): Live system

## Quick Start

```bash
# 1. Start the dev container
docker compose up -d

# 2. Wait for systemd to initialize (~5 seconds)
sleep 5

# 3. Run Ansible playbook against dev container
cd ansible
ansible-playbook -i inventory/dev.ini site.yml --check

# 4. Apply changes (remove --check)
ansible-playbook -i inventory/dev.ini site.yml

# 5. SSH into container to verify
ssh -p 2222 root@localhost  # password: dev

# 6. Tear down when done
docker compose down
```

## Testing Specific Roles

```bash
# Test only security role
ansible-playbook -i inventory/dev.ini site.yml --tags security

# Test with verbose output
ansible-playbook -i inventory/dev.ini site.yml -vvv
```

## Rebuilding Container

```bash
# Rebuild after Containerfile changes
docker compose build --no-cache
docker compose up -d
```

## Notes

- Container runs with `privileged: true` to support systemd and kernel features
- SSH available on `localhost:2222`
- Root password: `dev`
- Container uses Debian 13 (Trixie) to match production
- Changes are ephemeral - destroyed when container stops
