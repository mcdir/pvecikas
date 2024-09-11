
[project pvecikas: github](https://github.com/mcdir/pvecikas/)

# Pvecikas (Proxmox cloud-init tools)
Shell Script tools to create/delete VM cloud-init in Proxmox Virtual Environment (PVE) like [proxmox-cloud-init-tools](https://github.com/kmee/proxmox-cloud-init-tools/),
but more complex.

# Usage
### Prepare project
Login on your Proxmox VE server over SSH or Console Shell
Clone pvecikas (proxmox cloud-init) project
```
git clone https://github.com/mcdir/pvecikas/
cd pvecikas
```

### Create templates, etc.

```bash
# Prepare
sudo apt-get install pytho3-jinja2 -y
#
cd ./.utils 
cp ./.env-example.yml ./.env.yml
# example for ubuntu
cd ..
cd ubuntu/jammy-22.04/
./init.sh
nano ./.envs/.env_local.sh
# update next variables or keep it as it is:
# export PV_STORAGE_ID="local-lvm"
# export PV_STORAGE_TYPE="lvm"
```

update [.env.yml](./.utils/.env.yml) with you variables, like pub ssh key, default user password, etc.
and run next:

```bash
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

- [prepare-os.sh](.global/.common/prepare-os.sh) - prepare proxmox os for next step
- [prepare-pve.sh](.global/.common/prepare-pve.sh) — copy cloud-init templates to proxmox environment
- [prepare-virt-customize.sh](.global/.common/prepare-virt-customize.sh) — prepare VM using virt-customize

## Proxmox
- [qm-clone-vm.sh](.global/.common/qm-clone-vm.sh) - clone vm via qm and env
- [qm-create-vm.sh](.global/.common/qm-create-vm.sh) - create vm via qm and env
- [qm-destroy-vm.sh](.global/.common/qm-destroy-vm.sh) - destroy vm via qm and env
- [qm-stop-vm.sh](.global/.common/qm-stop-vm.sh) - stop vm via qm and env


### Features
1. Auto cloud images download
- Debian 9 - Stretch
- Debian 10 - Buster
- Debian 11 - Bullseye 11
- Ubuntu Server 18.04 LTS - Bionic
- Ubuntu Server 20.04 LTS - Focal
- Ubuntu Server 22.04 LTS - Jammy
- Ubuntu Server 24.04 LTS - Noble

2. Set VM Hostname
3. Set VM Description
4. Memory (any, via params)
5. CPU Cores - @todo
6. CPU Sockets - @todo
7. Storage destination (Local, NFS, LVM/LVM-Thin, etc)
8. Define and custom users.
9. Insert SSH authorized keys to users;
10. Select bridge network;
11. Select Static/IP or DHCP usage;
12. Define uniq VMID;
13. Can start or not, VM after deployment.

### Contributors

ME mcdirx@gmail.com
