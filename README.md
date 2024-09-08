
[project pvecikas: github](https://github.com/mcdir/pvecikas/)


# Prepare project, create templates, etc.

```bash
cp ./.utils 
cp ./.env-example.yml ./.env.yml
bash ./re-build.sh
```

# Motivation

There are many automation tools, but for a number of reasons they are not suitable for quickly creating and deleting a large number 
of virtual machines (VM) configured to work in specific environments.

For example, to create a hypothetical cluster, you usually need:
- internal self-signed certificates;
- registered ssh keys on the VM;
- certain pre-installed software;
- certain VM network settings;
- conveniently change the VM disk size.

This set of cli utilities is based on:
- cloud-init images;
- virt-customize;
- api and cli proxmox;
- everyone's favorite bash ;)

The project allows you to:
- create/delete virtual machines in the proxmox environment;
- prepare cloud-init images before creating virtual machines based on them in the proxmox environment;
- create cloud-init templates.

# Project architecture:

- .utils: virtual machine configuration templates

# List of utilities:

- ![prepare-os.sh](.global/.common/prepare-os.sh) - prepare proxmox os for next step
- ![prepare-pve.sh](.global/.common/prepare-pve.sh) — copy cloud-init templates to proxmox environment
- ![prepare-virt-customize.sh](.global/.common/prepare-virt-customize.sh) — prepare VM using virt-customize

## Proxmox
- ![qm-clone-vm.sh](.global/.common/qm-clone-vm.sh) - clone vm via qm and env
- ![qm-create-vm.sh](.global/.common/qm-create-vm.sh) - create vm via qm and env
- ![qm-destroy-vm.sh](.global/.common/qm-destroy-vm.sh) - destroy vm via qm and env
- ![qm-stop-vm.sh](.global/.common/qm-stop-vm.sh) - stop vm via qm and env
