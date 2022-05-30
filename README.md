# packer-proxmox-iso

This repo builds automatically Ubuntu VM templates (Ubuntu 22.04) for Proxmox  environment using Hashicorp's Packer.  

With this repo VM templates for the following Ubuntu systems can be built.

- Ubuntu Server 22.04


## How to use this repo

### Pre-requesites 

Make sure you have [Packer](https://www.packer.io/downloads) Version 1.7.1 or later installed. If you don't know Packer, it's a single commandline binary which only needs to be on your `PATH`.

### Step 1: Adjust credential variables, user data http file

Rename the file [credentials.pkr.hcl.template](credentials.pkr.hcl.template) to `credentials.pkr.hcl` and adjust the variables for your Proxmox.
```bash
mv credentials.pkr.hcl.template credentials.pkr.hcl
vim credentials.pkr.hcl
```

Adjust the file [user-data](user-data) as you wish.
```bash
cd ubuntu-server-template/http
vim user-data
```


### Step 2: Validate Packer

Validate Packer by using the following command.
```bash
packer validate -var-file="credentials.pkr.hcl" ./ubuntu-server-template/ubuntu-server-template.pkr.hcl
```

### Step 3: Build a VM Template

To build a VM template run the following `build`-scripts.
For example to build a Ubuntu Server 22.04 template run: 
```bash
./build-2204.sh
``` 

### Optional: Template default credentials

the default credentials after a successful build are   
Username: `test`   
Password: `test`  
    

To generate an encypted password for [user-data](.ubuntu-server-template/http/user-data) use the following command: 
```bash
openssl passwd -1
``` 
